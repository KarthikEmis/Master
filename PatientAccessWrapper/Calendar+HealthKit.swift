//
//  Calendar+HealthKit.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/24/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

extension Calendar {

  func midnightAtDate(date: Date) -> Date {
    let dateComponents = self.dateComponents([.month, .day, .year], from: date)
    return self.date(from: dateComponents)!
  }
  
  
}
