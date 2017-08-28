//
//  HealthKitAnchor.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import ObjectMapper
import HealthKit

//protocol Anchor {
//  associatedtype T
//  func value() -> T
//}

protocol Anchor {
  var value:Any {get}
}

struct HealthKitAnchor: Mappable {
  var anchors: [String:Int] = [:]
  var anchorDates: [String:String] = [:]
  var sampleTypes : [HealthKitSampleType] = []
  
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    anchors <- map["anchors"]
    anchorDates <- map["anchorDates"]
    self.createSampleTypes()
  }
  
  private mutating func createSampleTypes() {
    self.appendDiscreteTypes()
    self.appendCumulativeTypes()
  }
  
  private mutating func appendDiscreteTypes() {
    let discreteTypes = HealthKitSampleType.supportedTypes(types: .SampleTypeSupportedTypesDiscrete)
    
    for key: String in discreteTypes.keys {
      let anchor: NSNumber
      if let anchorNumber = anchors[key] {
        anchor = anchorNumber as NSNumber
      } else {
        anchor = NSNumber(value: 0)
        return
      }
      
      if let typeInfo = discreteTypes[key] {
        let anchorPoint = HealthKitAnchorPoint(number: anchor)
        let sampleType = HealthKitSampleType(sampleType: typeInfo[sampleTypeConstant] as? HKSampleType,
                                             unit: typeInfo[sampleUnitConstant] as? HKUnit,
                                             anchor: anchorPoint)
        sampleTypes.append(sampleType)
      }
    }
  }
  
  private mutating func appendCumulativeTypes() {
    let cumulativeTypes = HealthKitSampleType.supportedTypes(types: .SampleTypeSupportedTypesCumulative)
    if anchorDates.count > 0 {
      
      for key: String in cumulativeTypes.keys {
        let anchordate = HealthKitAnchorDate(string: anchorDates[key])
        if let typeInfo = cumulativeTypes[key] {
          let sampleType = HealthKitSampleType(sampleType: typeInfo[sampleTypeConstant] as? HKSampleType,
                                               unit: typeInfo[sampleUnitConstant] as? HKUnit,
                                               anchor: anchordate)
          
          sampleTypes.append(sampleType)
        }

      }
    }

  }
}
