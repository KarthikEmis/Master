//
//  HealthKitAnchorDate.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

class HealthKitAnchorDate: Anchor {
  
  private var dateString: String?

  init(string: String?) {
    self.dateString = (string != nil) ? string : AnchorDateMinimumDate
  }
  
//  func value() -> Date {
//    let dateFormatter = self.dateFormatter()
//    return dateFormatter.date(from: self.dateString!)!
//  }
  
  var value: Any {
    let dateFormatter = self.dateFormatter()
    return dateFormatter.date(from: self.dateString!)!
  }
  
  private func dateFormatter() -> DateFormatter {
    let dateFormatter : DateFormatter = {
      let dateFormatterInner = DateFormatter()
      dateFormatterInner.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
      return dateFormatterInner
    }()
    return dateFormatter
  }
  
}
