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
import SafariServices

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler, URLSessionDelegate {
  
  @IBOutlet weak var webContainerView: UIView!
  
  var wkWebView = WKWebView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let contentController = WKUserContentController()
    contentController.add(self, name: "notification")
    
    let config = WKWebViewConfiguration()
    config.userContentController = contentController
    
    wkWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), configuration: config)
    wkWebView.navigationDelegate = self
    wkWebView.uiDelegate = self as? WKUIDelegate
    wkWebView.scrollView.isScrollEnabled = true
    webContainerView.addSubview(wkWebView)
    wkWebView.customUserAgent = "iOS/WebWrapper"
    
    if let url = URL(string: "https://" + APIEndpoints.baseURL) {
      wkWebView.load(URLRequest(url: url))
    }
    
    wkWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
    
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
      } else if linkUrl == "export" {
        urlString = (message.body as! Dictionary <String, String>)["body"]!
        self.showDocumentInteractionController(withURL: URL(string: urlString)!)
        return
      }
      else {
        return
      }
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
  
  func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
    
    let cred = URLCredential(trust: challenge.protectionSpace.serverTrust!)
    completionHandler(.useCredential, cred)
    
  }
  
  func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
    
    
  }
  
  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    
    let requestURL = navigationAction.request.url
    if requestURL?.absoluteString.lowercased().range(of:"https://patient.info/search.asp?searchterm") != nil {
      let svc = SFSafariViewController(url: requestURL!)
      self.present(svc, animated: true, completion: nil)
    }
    
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
  
  private func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig)
    var request = URLRequest(url: url)
    
    request.httpMethod = "GET"
    
    let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
      if let tempLocalUrl = tempLocalUrl, error == nil {
        // Success
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          print("Success: \(statusCode)")
        }
        
        do {
          try FileManager.default.copyItem(at: tempLocalUrl, to: localUrl)
          completion()
        } catch (let writeError) {
          print("error writing file \(localUrl) : \(writeError)")
        }
        
      } else {
        print("Failure: %@", error?.localizedDescription ?? "Error");
      }
    }
    task.resume()
  }
  
  private func showDocumentInteractionController(withURL url:URL) {
    var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
    docURL = docURL?.appendingPathComponent("myFileName.pdf")
    self.load(url: url, to: docURL!) {
      DispatchQueue.main.async {
        let vc = UIActivityViewController(activityItems: [docURL!], applicationActivities: [])
        self.present(vc, animated: true)
      }
    }
  }
  
  private func openSafariWithURL(_ url: URL) {
    if #available(iOS 10.0, *) {
      UIApplication.shared.open(url, options: [:], completionHandler: nil)
    } else {
      UIApplication.shared.openURL(url)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}


