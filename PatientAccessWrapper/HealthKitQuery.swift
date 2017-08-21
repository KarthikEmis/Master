//
//  HealthKitQuery.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/10/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitQuery {
  
  private var sampleType: HealthKitSampleType
  private var healthKitManager: HealthKitManager
  
  init(sampleType: HealthKitSampleType?, healthKitManager: HealthKitManager?) {
    self.sampleType = sampleType!
    self.healthKitManager = healthKitManager!
  }
  
  func performQueryWith(completionHandler:@escaping (HealthKitSampleCollection) -> ()) {
    if self.sampleType.isCumulativeType {
      self.performAnchoredQueryWith(completionHandler: completionHandler)
    } else {
      self.performStatisticsQueryWith(completionHandler: completionHandler)
    }
  }
  
  private func performAnchoredQueryWith(completionHandler:@escaping (HealthKitSampleCollection) -> ()) {
    if !(self.sampleType.anchor.value is NSNumber) {
      if (completionHandler) {
        completionHandler([[EPASampleCollection alloc] init]);
      }
      return;
    }
    NSNumber *anchorPoint = (NSNumber *)self.sampleType.anchor.value;
    
  }
  
  private func performStatisticsQueryWith(completionHandler:@escaping (HealthKitSampleCollection) -> ()) {
    
    
  }
  
}
