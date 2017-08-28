//
//  GetAnchorsRequest.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/2/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import Alamofire

class GetAnchorsRequest: RequestType {
  
  var path: String {
    return APIEndpoints.anchors + "/" + uuid
  }
  var method: HTTPMethod {
    return .get
  }
  
  var encoding: ParameterEncoding {
    return JSONEncoding.default
  }
  
  var parameters: [String: Any]? {
    return nil
  }
  
  var responseSerializer: DataResponseSerializer<HealthKitAnchor> {
    return EntitySerializer.objectSerializer()
  }
  
  private let uuid: String
  
  init(_ uuidString: String) {
    uuid = uuidString
  }
}
