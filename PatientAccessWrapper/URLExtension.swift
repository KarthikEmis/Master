//
//  URLExtension.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 9/12/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation

extension URL {
  var params: [String: String]? {
    if let urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) {
      if let queryItems = urlComponents.queryItems {
        var params = [String: String]()
        queryItems.forEach{
          params[$0.name] = $0.value
        }
        return params
      }
    }
    return nil
  }
}
