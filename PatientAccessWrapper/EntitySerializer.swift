//
//  EntitySerializer.swift
//  PatientAccessWrapper
//
//  Created by Maxim Mylashko on 8/3/17.
//  Copyright © 2017 uk.co.patient. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

struct EntitySerializer<T: Mappable> {
  
  // MARK: - Object serialization
  static func objectSerializer(with keyPath: String? = nil) -> DataResponseSerializer<T> {
    return DataRequest.ObjectMapperSerializer(keyPath)
  }
  
  // MARK: - Collection serialization
  static func collectionSerializer(with keyPath: String? = nil) -> DataResponseSerializer<[T]> {
    return DataRequest.ObjectMapperArraySerializer(keyPath)
  }
}

struct EmptySerializer {
  
  // MARK: - Empty serialization
  static func serializer() -> DataResponseSerializer<Bool> {
    return DataResponseSerializer { _, response, _, error in
      if let response = response, response.statusCode >= 300 {
        return .failure(errSecInternalError as! Error)
      } else if let error = error {
        return .failure(error)
      }
      
      return .success(true)
    }
  }
  
}
