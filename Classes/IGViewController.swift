//
//  IGViewController.swift
//  WXSocial_Example
//
//  Created by Woxapp on 27.11.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit
import WebKit

class IGViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var _webView: UIWebView!
    var stringURL: String = ""
    var handler: Handler = nil
    var parameters: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _webView.loadRequest(URLRequest(url: URL(string: stringURL)!))
    }

    //MARK - UIWebView methods
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request)
        let query = request.url?.query ?? ""
        if query.contains("code=") {
            requestToken(code: instagramCode(from: query))
            return false
        }
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        print("did start")
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        print("did finished")
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        print("did fail")
    }
    
    //MARK - Actions
    
    @IBAction func back(_ sender: UIBarButtonItem?) {
        _webView.stopLoading()
        dismiss(animated: true) {
            self.handler?(ResponseContent())
        }
    }
    
    //MARK - Helper methods
    
    func requestToken(code : String) {
        parameters["code"] = code
        Communicator.igToken(parameters: parameters, completion: {[weak self] user in
            guard let wself = self else {return}
            if user.success == true {
                wself.handler?(user)
                wself.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func instagramCode(from query : String) -> String {
        let components = query.components(separatedBy: "=")
        return components.last ?? ""
    }

}
