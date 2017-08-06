//
//  HealthKitNetworkService.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/4/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

typealias GetAnchorsCompletion = (RequestResult<Any>) -> Void

protocol HealthKitNetworkServiceInterface {
    func getAnchors(uuidString: String, completion: @escaping GetAnchorsCompletion)
}

final class HealthKitNetworkService: HealthKitNetworkServiceInterface {

    // MARK: - Private properties
    private let apiClient = APIClient()

    // MARK: - Methods

    func getAnchors(uuidString: String, completion: @escaping GetAnchorsCompletion) {
        let getAnchorsRequest = GetAnchorsRequest(uuidString)
        apiClient.performRequest(getAnchorsRequest).handleResult(completion: completion)
    }
}
