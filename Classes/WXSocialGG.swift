import UIKit
import SafariServices
import GoogleSignIn

class WXSocialGG: NSObject, GIDSignInUIDelegate, GIDSignInDelegate, SFSafariViewControllerDelegate {

    var completion: Handler = nil
    var currentViewController: UIViewController? {
        return UIApplication.topViewController()
    }
    
    func auth(handler: Handler) {
        completion = handler
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        let rUser: ResponseContent = ResponseContent()
        if (error == nil) {
            rUser.firstName = user.profile.name
            rUser.email = user.profile.email
            rUser.image = user.profile.imageURL(withDimension: 250).absoluteString
            rUser.success = true
            completion?(rUser)
        } else {
            print("\(error.localizedDescription)")
            completion?(rUser)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user:GIDGoogleUser!, withError error: Error!) {
        print("google+ disconnected user")
    }
    
    func logout() {
        GIDSignIn.sharedInstance().signOut()
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        currentViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        currentViewController?.dismiss(animated: true, completion: nil)
    }
    
    func share(content: ShareContent, handler: Handler) {
        var urlComponents = URLComponents(string:"https://plus.google.com/share")
        urlComponents?.queryItems = [URLQueryItem(name: "text", value: content.text)]
        guard let url = urlComponents?.url else {return}
        let safari = SFSafariViewController(url: url)
        safari.delegate = self
        safari.modalPresentationStyle = .overFullScreen
        currentViewController?.present(safari, animated: true, completion: nil)
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.delegate = nil
        controller.dismiss(animated: true, completion: nil)
    }
    
}
