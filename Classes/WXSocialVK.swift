import UIKit
import VK_ios_sdk

class WXSocialVK: NSObject, VKSdkDelegate, VKSdkUIDelegate {

    let vkPermissions : [String] = [VK_PER_EMAIL, VK_PER_PHOTOS, VK_PER_WALL, VK_PER_FRIENDS]
    var completion : Handler = nil
    var vkInstance : VKSdk
    
    var currentViewController : UIViewController? {
        return UIApplication.topViewController()
    }
    
    static var vkontakteScheme: [String: String] = {
        guard let array = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: String]]
            else {
                return [:]
        }
        guard let vkontakte = array.filter({ scheme in
            return scheme["CFBundleURLName"]?.contains("vk") ?? false
        }).first
            else {
                return [:]
        }
        return vkontakte
    }()
    
    let vkAppID : String = {
        return vkontakteScheme["CFBundleURLName"] ?? ""
    }()
    
    override init() {
        vkInstance = VKSdk.initialize(withAppId: vkAppID)
        super.init()
        vkInstance.register(self)
        vkInstance.uiDelegate = self
    }
    
    func auth(handler: Handler) {
        completion = handler
        logout()
        VKSdk.authorize(vkPermissions)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult?) {
        if result == nil || result?.token == nil {
            self.completion?(ResponseContent())
            return
        }
        let user: ResponseContent = ResponseContent()
        user.email = result?.token.email
        user.socialToken = result?.token.accessToken
        VKApi.users().get([VK_API_FIELDS: "name, photo_max_orig"]).execute(resultBlock: { response in
            guard let array = response?.json as? [AnyObject]
                else {
                    self.completion?(ResponseContent())
                    return
            }
            if let dictionary = array.first as? [String: AnyObject] {
                user.firstName = dictionary["first_name"] as? String
                user.lastName = dictionary["last_name"] as? String
                user.image = dictionary["photo_max_orig"] as? String
                user.success = true
            }
            self.completion?(user)
        }, errorBlock: nil)
    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        currentViewController!.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkWillDismiss(_ controller: UIViewController?) {
        controller?.dismiss(animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print("error in captcha")
    }
    
    func vkSdkAcceptedUserToken(_ token: VKAccessToken!) {
        print("Accepted user token")
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("authorization Failed")
    }
    
    func logout() {
        VKSdk.forceLogout()
    }
    
    func share(content: ShareContent, handler: Handler) {
        let shareDialog = VKShareDialogController()
        shareDialog.text = ""
        shareDialog.uploadImages = [VKUploadImage(image: UIImage(named: "1"), andParams: VKImageParameters.pngImage())]
        shareDialog.completionHandler = ({ dialog, result in
            self.currentViewController?.dismiss(animated: true, completion:nil)
        })
        currentViewController?.present(shareDialog, animated: true, completion:nil)
    }
    
}
