//
//  WebViewControllerExtension.swift
//  VK_app
//
//  Created by macbook on 28.11.2020.
//

import UIKit
import WebKit

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        let token = params["access_token"]
        Session.storedSession.token = token ?? ""
        decisionHandler(.cancel)
        performSegue(withIdentifier: "friendsSegue", sender: nil)
    }
}
