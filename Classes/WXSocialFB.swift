//
//  WXSocialFB.swift
//  WXSocial_Example
//
//  Created by Woxapp on 27.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Social

class WXSocialFB: NSObject, FBSDKLoginButtonDelegate, FBSDKSharingDelegate {

    let permissions: [String] = ["public_profile", "email", "user_friends"]
    let parameters: [AnyHashable: Any] = ["fields":"first_name, last_name, picture.type(large), email"]
    
    var currentViewController: UIViewController? {
        return UIApplication.topViewController()
    }
    
    func auth(handler: Handler) {
        logout()
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: permissions, from: currentViewController, handler: { response, error  in
            FBSDKGraphRequest(graphPath: "me", parameters: self.parameters).start { (connection, response, error) -> Void in
                if response == nil {
                    handler?(ResponseContent())
                    return
                }
                let user: ResponseContent = ResponseContent()
                user.socialToken = FBSDKAccessToken.current().tokenString
                if let result = response as? [String: Any] {
                    user.firstName = result["first_name"] as? String
                    user.lastName = result["last_name"] as? String
                    user.email = result["email"] as? String
                    if let picture = result["picture"] as? [String : Any] {
                        if let data = picture["data"] as? [String : Any] {
                            user.image = data["url"] as? String ?? ""
                        }
                    }
                    user.success = true
                }
                handler?(user)
            }
        })
    }
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        logout()
    }
    
    func logout() {
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    func share(content: ShareContent, handler: Handler) {
        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        composeSheet?.setInitialText(content.text)
        composeSheet?.add(content.image)
        currentViewController?.present(composeSheet!, animated: true, completion: nil)
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable: Any]!) {}
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {}
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {}
    
}
