//
//  LoginNetworkService.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/2/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

final class LoginNetworkService {
    
    // MARK: - Private properties
    private let apiClient = APIClient()
    
    // MARK: Methods.
    func signIn(userName: String, password: String, completion: @escaping (RequestResult<BearerCredentials>) -> Void) {
//        let signInRequest = SignInRequest(userName: userName, password: password)
//        apiClient.performRequest(signInRequest).handleResult { (result: RequestResult<BearerCredentials>) in
//            switch result {
//            case .success(let verifiedCredentials):
//                let credentials = Credentials(userName: userName, password: password, bearerCredentials: verifiedCredentials)
//                completion(.success(credentials))
//                
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
    }
}
