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
  static let baseURL = "demo-web.patient-access.co.uk/"
#elseif TEST
  static let baseURL = "alpha-web.patient-access.co.uk/"
#else
  static let baseURL = "beta-web.patient-access.co.uk/"
#endif
  
  static let anchors = "api/api/healthkit/anchors"
}
