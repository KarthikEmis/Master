//
//  HealthKitSample.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitSample {
  
  var sample: HKSample?
  var sampleType: HealthKitSampleType?
  
  
  init(sample: HKSample?, type: HealthKitSampleType?) {
    self.sampleType = type
    self.sample = sample
  }
  
  func dictionaryRepresentation() -> Dictionary<String, Any> {

    let dateFormatter : DateFormatter = {
      let dateFormatterInner = DateFormatter()
      dateFormatterInner.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      return dateFormatterInner
    }()

    let sampleValue = HealthKitSampleValue(self.sample, type: self.sampleType)
    let dictionary = ["uuid": self.sample?.uuid.uuidString ?? "",
                      "source": self.sample?.sourceRevision.source.name ?? "",
                      "value": sampleValue.value(),
                      "end_date": dateFormatter.string(from: (self.sample?.endDate)!)] as [String : Any]
    
    return dictionary
  }

}
