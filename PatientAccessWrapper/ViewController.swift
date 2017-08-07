//
//  ViewController.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 7/24/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, URLSessionDelegate {

    @IBOutlet weak var webContainerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "notification")
        
/*        let scriptName = "GetUrl"

        
        let script = "webkit.messageHandlers.\(scriptName).postMessage(document.URL)"
        
        let scriptPath = Bundle.main.path(forResource: "script", ofType: "js")!
        let scriptString = try! String(contentsOfFile: scriptPath)
        
        
        //let userScript = WKUserScript(source: scriptString, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        let userScript = WKUserScript(source: script, injectionTime: WKUserScriptInjectionTime.atDocumentEnd, forMainFrameOnly: false)

        contentController.addUserScript(userScript)
        //contentController.add(self, name: "readyHandler")
        contentController.add(self, name: scriptName)
*/
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        let wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: webContainerView.frame.height), configuration: config)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self as? WKUIDelegate
        wkWebView.scrollView.isScrollEnabled = false
        webContainerView.addSubview(wkWebView)
        
        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        UserDefaults.standard.register(defaults: ["UserAgent": "iOS/WebWrapper"])

        if let url = URL(string: "https://" + APIEndpoints.baseURL) {
            wkWebView.load(URLRequest(url: url))
        }
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, cred)
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if keyPath == "loading" {
            
        }
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
        
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
