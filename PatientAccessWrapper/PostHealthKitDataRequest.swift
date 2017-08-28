//
//  PostHealthKitDataRequest.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import Alamofire

class PostHealthKitDataRequest: RequestType {
  
  var path: String {
    return APIEndpoints.postHealthKitData
  }
  var method: HTTPMethod {
    return .post
  }
  
  var parameters: [String: Any] {
    var tempParameters: [String: Any] = [:]
    tempParameters["jsonData"] = message.jsonRepresentation()
    return tempParameters
  }
  
  var encoding: ParameterEncoding {
    return JSONEncoding.default
  }
  
  var responseSerializer: DataResponseSerializer<Bool> {
    return EmptySerializer.serializer()
  }
  
  private let message: HealthKitMessage
  
  init(_ healthKitMessage: HealthKitMessage) {
    message = healthKitMessage
  }

}
