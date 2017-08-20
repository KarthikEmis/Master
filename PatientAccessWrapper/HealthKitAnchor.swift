//
//  HealthKitAnchor.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import ObjectMapper

struct HealthKitAnchor: Mappable {
  var anchors: [String]?
  var anchorDates: [String]?
  
//  init(accessToken: String, expiresIn: String) {
//    self.accessToken = accessToken
//    self.expiresIn = expiresIn
//  }
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    anchors <- map["anchors"]
    anchorDates <- map["anchorDates"]
  }
}
