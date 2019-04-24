//
//  Communicator.swift
//  WXSocial_Example
//
//  Created by Woxapp on 27.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import Alamofire

class Communicator: NSObject {

    static let shared = Communicator()
    var sessionManager = Alamofire.SessionManager()
    
    override init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        sessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    private static var manager : Alamofire.SessionManager {
        return shared.sessionManager
    }
    
    private static func sendRequest(request : String, method: Alamofire.HTTPMethod, parameters: [String : Any]?, headers : [String : String]?, completion : @escaping([String : AnyObject]) -> Void) {
        let encoding : ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        manager.request(request, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON(completionHandler: { response in
            checkResponse(response: response, completion: { response in
                _ = gotError(dictionary: response)
                completion(response)
            })
        })
    }
    
    static func igToken(parameters: [String: String], completion : Handler) {
        let request = "https://api.instagram.com/oauth/access_token"
        manager.request(request, method: .post, parameters: parameters, encoding: URLEncoding.default, headers: ["Content-Type" : "application/x-www-form-urlencoded"]).responseJSON(completionHandler: { response in
            guard let dictionary = response.result.value as? [String : AnyObject]
                else {
                    return
            }
            let user: ResponseContent = ResponseContent()
            if let info = dictionary["user"] as? [String : AnyObject] {
                user.socialToken = dictionary["access_token"] as? String
                user.success = true
                let components = (info["full_name"] as? String)?.components(separatedBy: " ")
                user.firstName = components?.first
                user.lastName = components?.last
                user.image = info["profile_picture"] as? String
            }
            completion?(user)
        })
    }
    
    private static func checkResponse(response : DataResponse<Any>, completion: @escaping ([String : AnyObject]) -> Void) {
        guard let dictionary = response.result.value as? [String : AnyObject]
            else {
                manageTimeout(response: response)
                completion([:])
                return
        }
        completion(dictionary)
    }
    
    private static func gotError(dictionary : [String : AnyObject]) -> Bool {
        if let status = dictionary["status_code"] as? Int {
            if status == 200 || status == 9 {return false}
            ServerError.stringError(errorID: status)
            return true
        }
        return false
    }
    
    private static func manageTimeout(response : DataResponse<Any>) {
        if let error = response.result.error {
            if error._code == 4 {
                //JSON serialization error, ignoring
                return
            } else if error._code == NSURLErrorTimedOut || error._code == NSURLErrorCannotFindHost || error._code != -999 || error._code != -1008 {
                ServerError.stringError(errorID: 777)
            }
        }
    }
    
}
