//
//  BearerCredentials.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/3/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import ObjectMapper

struct BearerCredentials: Mappable {
    var accessToken: String?
    var expiresIn: String?
    
    init(accessToken: String, expiresIn: String) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
    }
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        accessToken <- map["access_token"]
        expiresIn <- map["expires_in"]
    }
}
