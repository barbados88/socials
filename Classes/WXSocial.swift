//
//  Social.swift
//  Social_Example
//
//  Created by Woxapp on 27.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
}

public enum SocialType {
    
    case vkontakte
    case instagram
    case facebook
    case twitter
    case google
    case linkedIn
    
}

public typealias Handler = ((ResponseContent) -> Void)?

public class ShareContent: NSObject {
    
    var text: String? = nil
    var link: String? = nil
    var image: UIImage? = nil
    var hashTag: String? = nil
    
}

public class ResponseContent: NSObject {
    
    var firstName: String? = nil
    var lastName: String? = nil
    var email: String? = nil
    var image: String? = nil
    var socialToken: String? = nil
    var success: Bool = false
    
}
//TODO: create one protocol for all socials, use context to understand social type
public class WXSocial: NSObject {

    static let shared = WXSocial()
    var vk: WXSocialVK = WXSocialVK()
    var fb: WXSocialFB = WXSocialFB()
    var tw: WXSocialTW = WXSocialTW()
    var ig: WXSocialIG = WXSocialIG()
    var gg: WXSocialGG = WXSocialGG()
    var li: WXSocialLI = WXSocialLI()
    
    public func authWith(social type: SocialType, handler: Handler) {
        switch type {
        case .vkontakte: vk.auth(handler: handler)
        case .instagram: ig.auth(handler: handler)
        case .facebook: fb.auth(handler: handler)
        case .twitter: tw.auth(handler: handler)
        case .google: gg.auth(handler: handler)
        case .linkedIn: li.auth(handler: handler)
        }
    }
    
    public func share(content: ShareContent, to type: SocialType, handler: Handler) {
        switch type {
        case .vkontakte: vk.share(content: content, handler: handler)
        case .instagram: ig.share(content: content, handler: handler)
        case .facebook: fb.share(content: content, handler: handler)
        case .twitter: tw.share(content: content, handler: handler)
        case .google: gg.share(content: content, handler: handler)
        case .linkedIn: li.share(content: content, handler: handler)
        }
    }
    
}
