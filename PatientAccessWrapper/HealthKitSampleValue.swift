//
//  HealthKitSampleValue.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitSampleValue {
  
  var sample:HKSample?
  var sampleType:HealthKitSampleType?
  
  init(_ hksample: HKSample?, type: HealthKitSampleType?) {
    self.sampleType = type
    self.sample = hksample
  }
  
  func value() -> Array<Any> {
    let array = [Any]()
    return array
  }
  
  
}

