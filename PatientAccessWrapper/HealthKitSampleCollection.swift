//
//  HealthKitSampleCollection.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitSampleCollection {
  
  var samples = [HealthKitSample]()
  var sampleType: HKSampleType?
  var anchor: NSNumber
  
  init(samples: Array<HealthKitSample>?, type: HKSampleType?, anchor: NSNumber) {
    self.samples = samples!
    self.sampleType = type
    self.anchor = anchor
  }
  
  func hasSamples() -> Bool {
    return self.samples.count > 0
  }
  
  func dictionaryRepresentation() -> Dictionary<String, Any> {
    
    var samplesArray = [Any]()
    
    for sample: HealthKitSample in self.samples {
      samplesArray.append(sample.dictionaryRepresentation())
    }
    
    let dictionary = ["samples": samplesArray,
                      "type": self.sampleType?.identifier ?? "",
                      "new_anchor": self.anchor] as [String : Any]
    
    return dictionary
  }

}
