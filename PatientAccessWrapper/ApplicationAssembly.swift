//
//  ApplicationAssembly.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/2/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import KeychainAccess

class ApplicationAssembly {
  
  static var shared = ApplicationAssembly()
  
  private(set) var userSession: UserSession!
  
  func assemble() {
    userSession = makeUserSession()
  }
  
  private func makeUserSession() -> UserSession {
    let loginNetworkService = LoginNetworkService()
    let keychain = Keychain(service: "com.PatientAccess.keychain")
    let credentialsStorage = CredentialsStorageService(repository: keychain)
    let userSession = UserSession(loginNetworkService: loginNetworkService, credentialsStorage: credentialsStorage)
    
    return userSession
  }
  
}
