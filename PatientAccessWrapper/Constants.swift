//
//  Constants.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/2/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

enum APIEndpoints {
  
#if DEMO
  static let baseURL = "demo266.dataart.com/"
#elseif TEST
  static let baseURL = "pacweb.vrn.dataart.net/test/"
#else
  static let baseURL = "pacweb.vrn.dataart.net/dev/"
#endif
  
  static let anchors = "api/api/healthkit/anchors"
}
