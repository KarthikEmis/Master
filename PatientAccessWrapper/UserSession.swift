//
//  UserSession.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/2/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

class UserSession {
    
    // MARK: - Properties
    var accessToken: String? {
        return credentialsStorage.credentials?.accessToken
    }
    
    // MARK: - Private properties
    private let loginNetworkService: LoginNetworkService
    private var credentialsStorage: CredentialsStorageService
    
    // MARK: - Init
    init(loginNetworkService: LoginNetworkService, credentialsStorage: CredentialsStorageService) {
        self.loginNetworkService = loginNetworkService
        self.credentialsStorage = credentialsStorage
    }
    
    // MARK: - Methods
    func signIn(userName: String, password: String, completion: @escaping (RequestResult<()>) -> Void) {
        //HUDWrapper.show()
        self.loginNetworkService.signIn(userName: userName, password: password) { [weak self] result in
            //HUDWrapper.dismiss()
            guard let strongSelf = self else { return }
            
            switch result {
            case .success(let credentials):
                strongSelf.credentialsStorage.credentials = credentials

                var errorObject: Error? = nil
                //call completion block for signIn if both practice and account are loaded
                let successBlock: () -> Void = {
                    if errorObject == nil {
                        completion(.success())
                    } else {
                        //call completion with error
                        completion(.failure(errorObject!))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func receivedToken(tokenString: String) {
        credentialsStorage.credentials = BearerCredentials(accessToken: tokenString, expiresIn: "")
    }
    
    func cleanUp() {
        credentialsStorage.clean()
    }
}
