//
//  HealthKitQuantitySampleValue.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitQuantitySampleValue: HealthKitSampleValue {
  
  override func value() -> Array<Any> {
    let quantitySample = self.sample as! HKQuantitySample
    var valueForUnit = quantitySample.quantity.doubleValue(for: (self.sampleType?.sampleUnit)!)
    
    if (self.sampleType?.isPercentageValueType)! {
      valueForUnit *= 100
    }
    return [valueForUnit]
  }
}
