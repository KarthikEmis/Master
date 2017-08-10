//
//  RequestType.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/2/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import Alamofire

public typealias Method = Alamofire.Method

public enum URLPrefix: String {
  case HTTP = "http://"
  case HTTPS = "https://"
}

public enum URLPostfix: String {
  case Version1 = ""
}

public protocol RequestType {
  
  associatedtype ResponseObject
  
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var urlPrefix: URLPrefix { get }
  var urlPostfix: URLPostfix { get }
  var parameters: [String: Any] { get }
  var headers: [String: String] { get }
  var encoding: ParameterEncoding { get }
  var responseSerializer: DataResponseSerializer<ResponseObject> { get }
}

public protocol MultipartType: RequestType {
  
  var data: [String: Any]? { get }
}

extension MultipartType {
  
  var data: [String: Any]? {
    return nil
  }
}

extension RequestType {
  
  public var baseURL: String {
    return APIEndpoints.baseURL
  }
  
  public var urlPrefix: URLPrefix {
    return .HTTPS
  }
  
  public var urlPostfix: URLPostfix {
    return .Version1
  }
  
  public var method: HTTPMethod {
    return .get
  }
  
  public var parameters: [String: Any] {
    return [:]
  }
  
  public var headers: [String: String] {
    return [:]
  }
  
  public var encoding: ParameterEncoding {
    return URLEncoding.default
  }
  
  public var responseSerializer: DataResponseSerializer<Any> {
    return DataRequest.jsonResponseSerializer()
  }
}
