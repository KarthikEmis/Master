//
//  APIClient.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/3/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import BoltsSwift
import Alamofire

public typealias RequestTask = Alamofire.Request

class APIClient {
  
  private lazy var manager : Alamofire.SessionManager = {
    let serverTrustPolicies: [String: ServerTrustPolicy] = [
      "pacweb.vrn.dataart.net": .disableEvaluation,
      "demo266.dataart.com": .disableEvaluation
    ]
    let configuration = URLSessionConfiguration.default
    configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
    let manager = Alamofire.SessionManager(
      configuration: configuration,
      serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies)
    )
    
    manager.delegate.taskDidReceiveChallenge = { session, _, challenge in
      print("Got challenge: \(challenge), in session \(session)")
      var disposition: URLSession.AuthChallengeDisposition = .useCredential
      var credential: URLCredential = URLCredential()
      
      if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust){
        disposition = URLSession.AuthChallengeDisposition.useCredential
        //credential = URLCredential(forTrust: challenge.protectionSpace.serverTrust!)
        credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

      }
      return(disposition, credential)
    }
    
    return manager
  }()
  
  func performRequest<T: RequestType>(_ request: T, requestURL: URL? = nil) -> Task<T.ResponseObject> {
    let url: URL
    if let requestURL = requestURL {
      url = requestURL
    } else {
      let urlString = request.urlPrefix.rawValue +
        request.baseURL +
        request.urlPostfix.rawValue +
        request.path
      url = URL(string: urlString)!
    }
    
    var headers = request.headers
    
    if let token = ApplicationAssembly.shared.userSession.accessToken {
      headers["Authorization"] = "Bearer " + token
    }
    
    let source = TaskCompletionSource<T.ResponseObject>()
    
    let apiRequest = manager.request(
      url,
      method: request.method,
      parameters: nil,
      encoding: request.encoding,
      headers: headers
    )
    
    apiRequest.validate(statusCode: 200..<300).response(responseSerializer: request.responseSerializer) { response in
      switch response.result {
      case .success(let result):
        source.set(result: result)
      case .failure(let error):
        source.set(error: error)
      }
    }
    
    return source.task
  }
}

extension Task {
  
  func handleResult<T>(successOperation: ((T) -> Void)? = nil, completion: ((_ result: RequestResult<T>) -> Void)?) {
    continueWith { task in
      if let error = task.error {
        completion?(.failure(error))
      } else {
        guard let result = task.result as? T else {
          fatalError("Wrong generic type")
        }
        
        successOperation?(result)
        completion?(.success(result))
      }
    }
  }
}
