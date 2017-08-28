//
//  HealthKitMessage.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/16/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import UIKit

class HealthKitMessage {
  
  var sampleCollections = [HealthKitSampleCollection]()
  
  init(withSampleCollections sampleCollections: Array <HealthKitSampleCollection>) {
    self.sampleCollections = sampleCollections
  }
  
  func dictionaryRepresentation() -> Dictionary<String, Any> {
    
    var samplesArray = [Dictionary<String, Any>]()
    
    for sampleCollection: HealthKitSampleCollection in self.sampleCollections {
      if sampleCollection.hasSamples() {
        samplesArray.append(sampleCollection.dictionaryRepresentation())
      }
    }
    
    let dictionary = ["sample_collections": samplesArray,
                      "device_identifier": UIDevice.current.identifierForVendor?.uuidString as Any] as [String : Any]
    
    return dictionary
  }
  
  func jsonRepresentation() -> String? {
    
    var jsonData: Data?
    do {
    jsonData = try JSONSerialization.data(withJSONObject: self.dictionaryRepresentation(),
                                          options: [])
    }
    catch {
      print(error)
    }

    
    if (jsonData?.count)! > 0 {
      return String(data: jsonData!, encoding: .ascii)!
    }

    return nil
  }

}
