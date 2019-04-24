import UIKit
import LinkedinSwift

class WXSocialLI: NSObject {

    var currentViewController: UIViewController? {
        return UIApplication.topViewController()
    }

    static var linkedInScheme: [String: String] = {
        guard let array = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: String]]
            else {
                return [:]
        }
        guard let linkedIn = array.filter({ scheme in
            return (scheme["CFBundleURLName"]) == "linkedIn"
        }).first
            else {
                return [:]
        }
        return linkedIn
    }()

    private let clientID: String = {
        return linkedInScheme["client_id"] ?? ""
    }()

    private let redirectURI: String = {
        return linkedInScheme["redirect_uri"] ?? ""
    }()

    private let clientSecret: String = {
        return linkedInScheme["client_secret"] ?? ""
    }()

    private let state: String = {
        return linkedInScheme["state"] ?? ""
    }()

    private let permissions: [String] = {
        return ["r_basicprofile", "r_emailaddress"]
    }()

    private var requestURL : String {
        return "https://api.linkedin.com/v1/people/~?format=json"
    }

    public func auth(handler: Handler) {
        let linkedinHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration.init(clientId: clientID, clientSecret: clientSecret, state: state, permissions: permissions, redirectUrl: redirectURI))
        let rUser: ResponseContent = ResponseContent()
        linkedinHelper.authorizeSuccess({ (lsToken) -> Void in
            linkedinHelper.requestURL(self.requestURL, requestType: LinkedinSwiftRequestGet, success: { response in
                print(response)
                rUser.email = "email@mail.com"
                rUser.firstName = "first_name"
                handler?(rUser)
            }) { error in
                print(error.localizedDescription)
            }
        }, error: { error in
            print(error.localizedDescription)
        }, cancel: {
            handler?(rUser)
        })
    }

    public func share(content: ShareContent, handler: Handler) {}

}
