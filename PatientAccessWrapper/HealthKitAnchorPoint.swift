//
//  HealthKitAnchorPoint.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

class HealthKitAnchorPoint {
  
  private var number: NSNumber?

  init(number: NSNumber?) {
    self.number = number
  }
  
  func value() -> NSNumber {
    return self.number!
  }
  
}
