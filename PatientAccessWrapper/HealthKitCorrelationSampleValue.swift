//
//  HealthKitCorrelationValue.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitCorrelationSampleValue: HealthKitSampleValue {
  
  override func value() -> Array<Any> {
    
    var correlatedSamples: [Any] = []
    let correlation = self.sample as! HKCorrelation
    for sample: HKSample in Array(correlation.objects) {
      if sample is HKQuantitySample {
        let quantitySample = self.sample as! HKQuantitySample
        let sampleValue = HealthKitSampleValue(quantitySample, type: self.sampleType)
        
        var dictionary: Dictionary<String, Any> = [:]

        dictionary["value"] = sampleValue.value()
        dictionary["type"] = quantitySample.quantityType.identifier
        dictionary["uuid"] = quantitySample.uuid.uuidString

        correlatedSamples.append(dictionary)

      }
    }
    
    return correlatedSamples;

  }
  
}
