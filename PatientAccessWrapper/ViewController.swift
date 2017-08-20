//
//  ViewController.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 7/24/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import UIKit
import WebKit
import EventKit

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
        wkWebView.scrollView.isScrollEnabled = true
        webContainerView.addSubview(wkWebView)
        
        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        UserDefaults.standard.register(defaults: ["UserAgent": "iOS/WebWrapper"])

        if let url = URL(string: "https://pacweb.vrn.dataart.net/dev/") {
            wkWebView.load(URLRequest(url: url))
        }
        
//        let link = "https://1fichier.com/?cx6r8k9uq7"
//        
//        let webcal = NSURL(string: link)
//        //UIApplication.shared.openURL(webcal! as URL)
//        //UIApplication.shared.open(webcal! as URL, options: [:]) { (Bool) in}
//        
//        //wkWebView.load(URLRequest(url: webcal! as URL))
//        let mxlManager = MXLCalendarManager()
//        mxlManager.scanICSFile(atRemoteURL: webcal as URL!) { (calendar : MXLCalendar!, error:Error!) in
//            
//            let eventsArray = calendar.events as! Array <MXLCalendarEvent>
//            EKEventStore.authorizationStatus(for: .event)
//            let eventStore = EKEventStore()
//            
//            for event : MXLCalendarEvent in eventsArray {
//                let calendarEvent = event.convertToEKEvent(on: Date(), store: eventStore)!
//                calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
//                
//                eventStore.requestAccess(to: .event) { (granted, error) in
//                    
//                    if (granted) && (error == nil) {
//                        print("granted \(granted)")
//                        print("error \(String(describing: error))")
//                        
//                        do {
//                            try eventStore.save(calendarEvent, span: .thisEvent)
//                        } catch let error as NSError {
//                            print("failed to save event with error : \(error)")
//                        }
//                        print("Saved Event")
//                      
//                        let alert = UIAlertController(title: "New Calendar Event", message: "Calendar Event Has Been Created", preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                    else{
//                        
//                        print("failed to save event with error : \(String(describing: error)) or access not granted")
//                        let alert = UIAlertController(title: "Error", message: "Error while creating a calendar event", preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                    }
//                }
//
//            }
//            
//        }
    
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
      
      let link = "https://1fichier.com/?cx6r8k9uq7"
      
      let webcal = NSURL(string: link)
      //UIApplication.shared.openURL(webcal! as URL)
      //UIApplication.shared.open(webcal! as URL, options: [:]) { (Bool) in}
      
      //wkWebView.load(URLRequest(url: webcal! as URL))
      let mxlManager = MXLCalendarManager()
      mxlManager.scanICSFile(atRemoteURL: webcal as URL!) { (calendar : MXLCalendar!, error:Error!) in
        
        let eventsArray = calendar.events as! Array <MXLCalendarEvent>
        EKEventStore.authorizationStatus(for: .event)
        let eventStore = EKEventStore()
        
        for event : MXLCalendarEvent in eventsArray {
          let calendarEvent = event.convertToEKEvent(on: Date(), store: eventStore)!
          calendarEvent.calendar = eventStore.defaultCalendarForNewEvents
          
          eventStore.requestAccess(to: .event) { [weak self] (granted, error) in
            
            guard let strongSelf = self else { return }

            if (granted) && (error == nil) {
              print("granted \(granted)")
              print("error \(String(describing: error))")
              
              do {
                try eventStore.save(calendarEvent, span: .thisEvent)
              } catch let error as NSError {
                print("failed to save event with error : \(error)")
              }
              print("Saved Event")
              
              let alert = UIAlertController(title: "New Calendar Event", message: "Calendar Event Has Been Created", preferredStyle: UIAlertControllerStyle.alert)
              alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
              DispatchQueue.main.sync {
                strongSelf.present(alert, animated: true, completion: nil)
              }
            }
            else{
              
              print("failed to save event with error : \(String(describing: error)) or access not granted")
              let alert = UIAlertController(title: "Error", message: "Error while creating a calendar event", preferredStyle: UIAlertControllerStyle.alert)
              alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
              DispatchQueue.main.sync {
                strongSelf.present(alert, animated: true, completion: nil)
              }            }
          }
          
        }
        
      }

      
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
