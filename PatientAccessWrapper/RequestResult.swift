//
//  RequestResult.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/2/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

public enum RequestResult<Value> {
    case success(Value)
    case failure(Error)
}

typealias VoidRequestResult = (RequestResult<Void>) -> Void
typealias BoolRequestResult = (RequestResult<Bool>) -> Void
