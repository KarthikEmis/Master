//
//  HealthKitQueryCollection.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/10/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitQueryCollection {
  
  private var queries : Array <HealthKitQuery>
  
  
  required init(queries: Array <HealthKitQuery>?) {
    self.queries = queries!
  }
  
  class func queryCollectionForSampleTypes(_ sampleTypes: Array<HealthKitSampleType>) -> HealthKitQueryCollection {
    
    var array : Array <HealthKitQuery> = []
    for sampleType: HealthKitSampleType in sampleTypes {
      let query = HealthKitQuery(sampleType: sampleType)
      array.append(query)
    }
    
    return self.init(queries: array)
  }
  
  func performQueriesWith(completionHandler:@escaping (Array<HealthKitSampleCollection>) -> ()) {

    var resultsArray : Array<HealthKitSampleCollection> = []
    
    for query: HealthKitQuery in self.queries {
      query.performQueryWith(completionHandler: { (sampleCollection) in
        
        OperationQueue.main.addOperation({ 
          resultsArray.append(sampleCollection)
          if resultsArray.count == self.queries.count {
            completionHandler(resultsArray)
          }
          
        })
      })
    }
    
  }

  
  
}
