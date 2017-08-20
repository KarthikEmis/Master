//
//  HealthKitSampleType.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/17/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitSampleType {
  
  public enum SampleTypeSupportedTypes {
    case SampleTypeSupportedTypesAll
    case SampleTypeSupportedTypesDiscrete
    case SampleTypeSupportedTypesCumulative
  }
  
  var sampleType:HKSampleType?
  var sampleUnit:HKUnit?
  var anchor:HealthKitAnchor?
  
  var isCumulativeType: Bool {
    let isStepCountType = self.sampleType?.isEqual(HKQuantityType.quantityType(forIdentifier:HKQuantityTypeIdentifier.stepCount))
    let isWalkingType = self.sampleType?.isEqual(HKQuantityType.quantityType(forIdentifier:HKQuantityTypeIdentifier.distanceWalkingRunning))

    return isStepCountType! || isWalkingType!
  }
  
  var isPercentageValueType: Bool {
    let isOxygenSaturation = self.sampleType?.isEqual(HKQuantityType.quantityType(forIdentifier:HKQuantityTypeIdentifier.oxygenSaturation))
    
    return isOxygenSaturation!
  }
  
  
  init(sampleType: HKSampleType?, unit: HKUnit?, anchor:HealthKitAnchor?) {
    self.sampleType = sampleType
    self.sampleUnit = unit
    self.anchor = anchor
  }
  
  class func supportedTypes(types: SampleTypeSupportedTypes) -> Dictionary<AnyHashable, Dictionary<String, Any>> {
    
    switch types {
    case .SampleTypeSupportedTypesAll:
      var typesDictionary = self.discreteTypes()
      typesDictionary.update(self.cumulativeTypes())
      return typesDictionary
    case .SampleTypeSupportedTypesDiscrete:
      return self.discreteTypes()
    case .SampleTypeSupportedTypesCumulative:
      return self.cumulativeTypes()
    }
    
  }
  
  private class func discreteTypes() -> Dictionary<AnyHashable, Dictionary<String, Any>> {
    return [HKQuantityTypeIdentifier.height:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.height)!,
             sampleUnitConstant:HKUnit.meterUnit(with: HKMetricPrefix.centi)],
            
           HKQuantityTypeIdentifier.bodyMass:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
             sampleUnitConstant:HKUnit.gramUnit(with: HKMetricPrefix.kilo)],
      
           HKQuantityTypeIdentifier.heartRate:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
             sampleUnitConstant:HKUnit.unitDivided(HKUnit.minute())],
      
           HKQuantityTypeIdentifier.oxygenSaturation:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!,
             sampleUnitConstant:HKUnit.percent()],
      
           HKQuantityTypeIdentifier.bloodGlucose:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bloodGlucose)!,
             sampleUnitConstant:HKUnit.moleUnit(with: HKMetricPrefix.milli,
                                    molarMass:HKUnitMolarMassBloodGlucose).unitDivided(by: HKUnit.liter())],
      
           HKQuantityTypeIdentifier.respiratoryRate:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.respiratoryRate)!,
             sampleUnitConstant:HKUnit.count().unitDivided(by: HKUnit.minute())],
      
           HKQuantityTypeIdentifier.bodyTemperature:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyTemperature)!,
             sampleUnitConstant:HKUnit.degreeCelsius()],
      
           HKQuantityTypeIdentifier.bodyMassIndex:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMassIndex)!,
             sampleUnitConstant:HKUnit.count()],
      
           HKQuantityTypeIdentifier.forcedVitalCapacity:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.forcedVitalCapacity)!,
             sampleUnitConstant:HKUnit.liter()],
      
           HKQuantityTypeIdentifier.forcedExpiratoryVolume1:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.forcedExpiratoryVolume1)!,
             sampleUnitConstant:HKUnit.liter()],
      
           HKQuantityTypeIdentifier.peakExpiratoryFlowRate:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.peakExpiratoryFlowRate)!,
             sampleUnitConstant:HKUnit(from:"L/min")],
      
           HKCorrelationTypeIdentifier.bloodPressure:
             [sampleTypeConstant:HKCorrelationType.correlationType(forIdentifier: HKCorrelationTypeIdentifier.bloodPressure)!,
             sampleUnitConstant:HKUnit.millimeterOfMercury()]
    ]
    
    
  }
  
  private class func cumulativeTypes() -> Dictionary<AnyHashable, Dictionary<String, Any>> {
    return [HKQuantityTypeIdentifier.distanceWalkingRunning:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
             sampleUnitConstant:HKUnit.meter()],
            
           HKQuantityTypeIdentifier.stepCount:
             [sampleTypeConstant:HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
             sampleUnitConstant:HKUnit.count()]
    ]
  }

  
}

extension Dictionary {
  mutating func update(_ other:Dictionary) {
    for (key,value) in other {
      self.updateValue(value, forKey:key)
    }
  }
}
