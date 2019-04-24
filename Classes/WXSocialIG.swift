import UIKit

class WXSocialIG: NSObject {

    var completion: Handler = nil
    var currentViewController: UIViewController? {
        return UIApplication.topViewController()
    }
    
    static var instagramScheme: [String: String] = {
        guard let array = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: String]]
            else {
                return [:]
        }
        guard let instagram = array.filter({ scheme in
            return (scheme["CFBundleURLName"]) == "instagram"
        }).first
            else {
                return [:]
        }
        return instagram
    }()
    
    private let clientID: String = {
        return instagramScheme["client_id"] ?? ""
    }()
    
    private let redirectURI: String = {
        return instagramScheme["redirect_uri"] ?? ""
    }()
    
    private let clientSecret: String = {
        return instagramScheme["client_secret"] ?? ""
    }()
    
    private var requestURL : String {
        return "https://api.instagram.com/oauth/authorize/?client_id=\(clientID)&redirect_uri=\(redirectURI)&response_type=code"
    }
    
    private var parameters: [String: String] {
        var p: [String: String] = [:]
        p["client_id"] = clientID
        p["client_secret"] = clientSecret
        p["grant_type"] = "authorization_code"
        p["redirect_uri"] = redirectURI
        return p
    }
    
    func auth(handler: Handler) {
        let vc: IGViewController = IGViewController(nibName: "IGViewController", bundle: nil)
        vc.stringURL = requestURL
        vc.parameters = parameters
        vc.handler = { user in
            handler?(user)
        }
        currentViewController?.present(vc, animated: true, completion: nil)
    }
    
    var documentController: UIDocumentInteractionController? = nil
    func share(content: ShareContent, handler: Handler) {
        let image = content.image
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let imagePath = path.appending("/image.igo")
        try? FileManager.default.removeItem(atPath: imagePath)
        try? UIImageJPEGRepresentation(image!, 1.0)?.write(to: URL(fileURLWithPath: imagePath), options: .atomicWrite)
        documentController = UIDocumentInteractionController(url: URL(fileURLWithPath: imagePath))
        documentController?.presentOptionsMenu(from:currentViewController!.view.frame, in: currentViewController!.view, animated: true)
    }
    
}
