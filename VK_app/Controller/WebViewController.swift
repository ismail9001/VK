//
//  WebViewController.swift
//  VK_app
//
//  Created by macbook on 24.11.2020.
//

import UIKit
import WebKit
import Alamofire
import RealmSwift

class WebViewController: UIViewController {
    
    @IBOutlet weak var webview: WKWebView! {
            didSet{
                webview.navigationDelegate = self
            }
        }
    let loginService = AuthorizationService()
    let friendsService = FriendService()
    let realm = try! Realm(configuration: Config.realmConfig)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.configuration.fileURL ?? "")
        loginService.getVKToken()
        
        var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "oauth.vk.com"
                urlComponents.path = "/authorize"
                urlComponents.queryItems = [
                    URLQueryItem(name: "client_id", value: "7697149"),
                    URLQueryItem(name: "display", value: "mobile"),
                    URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                    URLQueryItem(name: "scope", value: "262150"),
                    URLQueryItem(name: "response_type", value: "token"),
                    URLQueryItem(name: "v", value: "5.126")//,
                    //URLQueryItem(name: "revoke", value: "1")
                ]
                
                let request = URLRequest(url: urlComponents.url!)
        //webview.load(loginService.getVKToken())
        //webview.load(AF.request(url, method: .get, parameters: parameters))
        webview.load(request)
    }
}
