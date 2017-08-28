//
//  HealthKitNetworkService.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/4/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

typealias GetAnchorsCompletion = (RequestResult<Any>) -> Void
typealias PostHealthKitDataCompletion = (RequestResult<Any>) -> Void

protocol HealthKitNetworkServiceInterface {
  func getAnchors(uuidString: String, completion: @escaping GetAnchorsCompletion)
  func postHealthKitData(message: HealthKitMessage, completion: @escaping PostHealthKitDataCompletion)
}

final class HealthKitNetworkService: HealthKitNetworkServiceInterface {
  
  // MARK: - Private properties
  private let apiClient = APIClient()
  
  // MARK: - Methods
  
  func getAnchors(uuidString: String, completion: @escaping GetAnchorsCompletion) {
    let getAnchorsRequest = GetAnchorsRequest(uuidString)
    apiClient.performRequest(getAnchorsRequest).handleResult(completion: completion)
  }
  
  func postHealthKitData(message: HealthKitMessage, completion: @escaping PostHealthKitDataCompletion) {
    let postHealthKitDataRequest = PostHealthKitDataRequest(message)
    apiClient.performRequest(postHealthKitDataRequest).handleResult(completion: completion)
  }
}
