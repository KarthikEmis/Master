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
                                          options: .init(rawValue: 0))
    }
    catch {
      print(error)
    }
    
//    do {
//      let decoded = try JSONSerialization.jsonObject(with: jsonData!, options: .allowFragments)
//      print(decoded)
//
//    }
//    catch {
//      print(error)
//    }
    


    if (jsonData?.count)! > 0 {
      return String(data: jsonData!, encoding: .utf8)!
    }

    return nil
  }
  
  func convertSpecialCharacters(string: String) -> String {
    var newString = string
    let char_dictionary = [
      "&amp;" : "&",
      "&lt;" : "<",
      "&gt;" : ">",
      "&quot;" : "\"",
      "&apos;" : "'"
    ];
    for (escaped_char, unescaped_char) in char_dictionary {
      newString = newString.replacingOccurrences(of: escaped_char, with: unescaped_char, options: NSString.CompareOptions.literal, range: nil)
    }
    return newString
  }

}
