//
//  CredentialsStorageServiceImplementation.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/3/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import KeychainAccess

protocol RepositoryInterface: class {
    
    subscript(key: String) -> String? { get set }
}

extension Keychain: RepositoryInterface {}

final class CredentialsStorageService {
    
    struct InternalConstants {
        static let tokenKey = "com.PatientAccess.accessToken"
        static let expiresInKey = "com.PatientAccess.expiresIn"
    }
    
    // MARK: - Properties
    var credentials: BearerCredentials? {
        get {
            if _credentials == nil {
                fulfillCredentials()
            }
            
            return _credentials
        }
        set {
            if newValue != nil {
                _credentials = newValue
                updateRepository()
            }
        }
    }
    
    // MARK: - Private Properties
    private let repository: RepositoryInterface
    private var _credentials: BearerCredentials?
    
    // MARK: - Init
    init(repository: RepositoryInterface) {
        self.repository = repository
    }
    
    // MARK: - Methods
    func clean() {
        repository[InternalConstants.tokenKey] = nil
        repository[InternalConstants.expiresInKey] = nil
    }
    
    // MARK: - Private methods
    private func updateRepository() {
        repository[InternalConstants.tokenKey] = _credentials?.accessToken
        repository[InternalConstants.expiresInKey] = _credentials?.expiresIn
    }
    
    private func fulfillCredentials() {
        if
            let token = repository[InternalConstants.tokenKey],
            let expiresIn = repository[InternalConstants.expiresInKey]
        {
            _credentials = BearerCredentials(accessToken: token, expiresIn: expiresIn)
        }
    }
}
