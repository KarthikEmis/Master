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
  
  init(sampleType: HealthKitSampleType?) {
    self.sampleType = sampleType!
  }
  
  func performQueryWith(completionHandler:@escaping (HealthKitSampleCollection) -> ()) {
    if self.sampleType.isCumulativeType {
      self.performStatisticsQueryWith(completionHandler: completionHandler)
    } else {
      self.performAnchoredQueryWith(completionHandler: completionHandler)
    }
  }
  
  private func performAnchoredQueryWith(completionHandler:@escaping (HealthKitSampleCollection) -> ()) {
    if !(self.sampleType.anchor is HealthKitAnchorPoint) {
      //completionHandler(HealthKitSampleCollection())
      return;
    }
    
    let anchorPoint = (self.sampleType.anchor as! HealthKitAnchorPoint).value as! NSNumber
    let query: HKAnchoredObjectQuery
    
//    query = HKAnchoredObjectQuery(type: self.sampleType.sampleType!,
//                             predicate: nil,
//                                anchor: HKQueryAnchor.init(fromValue: Int(anchorPoint.uintValue)),
//                                 limit: HKObjectQueryNoLimit,
//                        resultsHandler: { (query, results, nil, newAnchor, error) in
//                        
//                          var array = [HealthKitSample]()
//                          for result:HKSample in results! {
//                            let healthKitSample = HealthKitSample(sample: result, type: self.sampleType)
//                            array.append(healthKitSample)
//                          }
//                          
//                          let healthKitSampleCollection = HealthKitSampleCollection(samples: array, type: self.sampleType.sampleType, anchor: newAnchor)
//                          completionHandler(healthKitSampleCollection)
//                          
//    })
    
    query = HKAnchoredObjectQuery(type: self.sampleType.sampleType!,
                                  predicate: nil,
                                  anchor: anchorPoint.intValue,
                                  limit: HKObjectQueryNoLimit,
                                  completionHandler: { (query, results, newAnchor, error) in
                                    
                                    if results == nil {
                                      return
                                    }
          
                                    var array = [HealthKitSample]()
                                    for result:HKSample in results! {
                                      let healthKitSample = HealthKitSample(sample: result, type: self.sampleType)
                                      array.append(healthKitSample)
                                    }
          
                                    let healthKitSampleCollection = HealthKitSampleCollection(samples: array, type: self.sampleType.sampleType, anchor: NSNumber(value: newAnchor))
                                    completionHandler(healthKitSampleCollection)
    })
    
    HealthKitManager.sharedInstance.healthKitStore.execute(query)
  }
  
  private func performStatisticsQueryWith(completionHandler:@escaping (HealthKitSampleCollection) -> ()) {
    if !(self.sampleType.anchor is HealthKitAnchorDate) {
      //completionHandler(HealthKitSampleCollection())
      return;
    }
    
    var dayComponents = DateComponents()
    dayComponents.day = 1
    
    var anchorDate = self.sampleType.anchor?.value as! Date
    anchorDate = Calendar.current.date(byAdding: dayComponents, to: anchorDate)!

    let quantityType = self.sampleType.sampleType as! HKQuantityType
    let gregorianCalendar = Calendar(identifier: .gregorian)
    let endDate = gregorianCalendar.midnightAtDate(date: Date())
    let beforeToday = HKQuery.predicateForSamples(withStart: anchorDate, end: endDate, options: [])
    let options = HKStatisticsOptions.cumulativeSum
    let query = HKStatisticsCollectionQuery(quantityType: quantityType,
                                            quantitySamplePredicate: beforeToday,
                                            options: options,
                                            anchorDate: anchorDate,
                                            intervalComponents: dayComponents)
    
    query.initialResultsHandler = {query, result, error in
      
      var array = [HealthKitSample]()
      result?.enumerateStatistics(from: anchorDate,
                                  to: endDate,
                                  with: { (result, stop) in
                                    let sumQuantity = result.sumQuantity()
                                    if sumQuantity != nil {
                                      let date = gregorianCalendar.midnightAtDate(date: result.startDate)
                                      let quantitySample = HKQuantitySample(type: quantityType,
                                                                            quantity: sumQuantity!,
                                                                            start: date,
                                                                            end: date)
                                      let sample = HealthKitSample(sample: quantitySample, type: self.sampleType)
                                      array.append(sample)
                                    }
      })
      var FIX_ME__🛠🛠🛠: AnyObject
      let sampleCollection = HealthKitSampleCollection(samples: array,
                                                       type: self.sampleType.sampleType,
                                                       anchor: NSNumber())
      completionHandler(sampleCollection)
    
    }
    
    HealthKitManager.sharedInstance.healthKitStore.execute(query)
  }
  
}
