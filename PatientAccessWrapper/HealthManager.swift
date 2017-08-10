//
//  HealthManager.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/6/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
  
  let healthKitStore = HKHealthStore()
  
  func authorizeHealthKit(completion: @escaping ((_ success:Bool, _ error:Error?) -> Void))
  {
    
    let healthKitTypesToRead: Set<HKObjectType> = [
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.respiratoryRate)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.forcedVitalCapacity)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.forcedExpiratoryVolume1)!,
      HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.peakExpiratoryFlowRate)!,
      ]
    
    if !HKHealthStore.isHealthDataAvailable()
    {
      let error = NSError(domain: "uk.co.patient.iOSPatientAccessWrapper", code: 2, userInfo: [NSLocalizedDescriptionKey:"HealthKit is not available on this Device"])
      
      completion(false, error)
      return;
    }
    
    healthKitStore.requestAuthorization(toShare: nil, read:healthKitTypesToRead) { (success, error) -> Void in
      completion(success,error)
    }
  }
  
}
