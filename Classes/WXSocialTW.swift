//
//  WXSocialTW.swift
//  WXSocial_Example
//
//  Created by Woxapp on 27.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Social
//import TwitterKit
//import TwitterCore

class WXSocialTW: NSObject {

    let parameters: [AnyHashable: Any] = ["include_email": "true", "skip_status": "true"]
    let loginURL: String = "https://api.twitter.com/1.1/account/verify_credentials.json"
    
    var currentViewController: UIViewController? {
        return UIApplication.topViewController()
    }
    
    func auth(handler: Handler) {
        logout()
//        Twitter.sharedInstance().logIn { session, error  in
//            let client = TWTRAPIClient.withCurrentUser()
//            let request = client.urlRequest(withMethod: "GET", url: self.loginURL, parameters: self.parameters, error: nil)
//            client.sendTwitterRequest(request) { response, data, connectionError in
//                let user: ResponseContent = ResponseContent()
//                do {
//                    if data != nil {
//                        let dictionary: NSDictionary = try JSONSerialization.jsonObject(with: data!, options:[]) as! NSDictionary
//                        user.firstName = dictionary["name"] as? String
//                        user.image = dictionary["profile_image_url_https"] as? String
//                        user.success = true
//                        handler?(user)
//                    }
//                } catch let error as NSError {
//                    print(error.localizedDescription)
//                    handler?(user)
//                }
//            }
//        }
    }
    
    func logout() {
//        if let userID = TWTRAPIClient.withCurrentUser().userID {
//            Twitter.sharedInstance().sessionStore.logOutUserID(userID)
//        }
    }
    
    func share(content: ShareContent, handler: Handler) {
        let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        composeSheet?.setInitialText(content.text)
        composeSheet?.add(content.image)
        currentViewController?.present(composeSheet!, animated: true, completion: nil)
        composeSheet?.completionHandler = { result in
            handler?(ResponseContent())
        }
    }
    
}
