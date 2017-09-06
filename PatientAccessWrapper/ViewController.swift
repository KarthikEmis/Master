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

    var wkWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let contentController = WKUserContentController()
        contentController.add(self, name: "notification")
      
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: webContainerView.frame.height), configuration: config)
        wkWebView.navigationDelegate = self
        wkWebView.uiDelegate = self as? WKUIDelegate
        wkWebView.scrollView.isScrollEnabled = true
        webContainerView.addSubview(wkWebView)
        
        wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)

        let userAgent = UIWebView().stringByEvaluatingJavaScript(from: "navigator.userAgent")! + " iOS/WebWrapper"
        //UserDefaults.standard.register(defaults: ["UserAgent": userAgent])
        wkWebView.customUserAgent = "iOS/WebWrapper"
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

      var urlString = ""
      if let linkUrl = (message.body as! Dictionary <String, String>)["name"] {
        if linkUrl == "iCal" {
          urlString = (message.body as! Dictionary <String, String>)["body"]!
        } else {
          return
        }
        print(linkUrl)
      }

      let webcal = NSURL(string: urlString)
      let mxlManager = MXLCalendarManager()
      mxlManager.scanICSFile(atRemoteURL: webcal as URL!) { (calendar : MXLCalendar!, error:Error!) in

        let eventsArray = calendar.events as! Array <MXLCalendarEvent>
        EKEventStore.authorizationStatus(for: .event)
        let eventStore = EKEventStore()

        for event : MXLCalendarEvent in eventsArray {
          let calendarEvent = event.convertToEKEvent(on: event.eventStartDate, store: eventStore)!

          eventStore.requestAccess(to: .event) { [weak self] (granted, error) in

            guard let strongSelf = self else { return }
            calendarEvent.calendar = eventStore.defaultCalendarForNewEvents

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
      //https://stackoverflow.com/a/25647768
      let javascriptString = "var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);"

          webView.evaluateJavaScript(javascriptString, completionHandler: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

