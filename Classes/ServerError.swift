//
//  ServerError.swift
//  WXSocial_Example
//
//  Created by Woxapp on 27.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

class ServerError: NSObject {

    private static var dictionary : [Int : String] {
        var dict : [Int : String] = [:]
        dict[777] = NSLocalizedString("Пожалуйста, проверьте подключение к сети.", comment:"")
        return dict
    }
    
    static func stringError(errorID : Int) {
        if errorID == 21 || errorID == 24 {return}
        if isShowing == true {return}
        if let message = dictionary[errorID] {
            showError(message: message)
        }
    }
    
    private static var isShowing : Bool {
        return UIApplication.topViewController() is UIAlertController
    }
    
    static func showError(message : String) {
        let alert = UIAlertController(title: NSLocalizedString("Система", comment: ""), message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        UIApplication.topViewController()?.present(alert, animated: false, completion: nil)
    }
    
}
