//
//  DefaultResponse.swift
//  NetworkStorageInterfaces
//
//  Created by chminii on 3/16/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import CoreModels

public struct DefaultResponse<R: Codable>: Codable {
  public let isSuccess: Bool
  public let message: String
  public let response: R?
  
  public init(isSuccess: Bool, message: String, response: R?) {
    self.isSuccess = isSuccess
    self.message = message
    self.response = response
  }
  
  public init(isSuccess: Bool, message: String, response: R? = nil) where R == EmptyResponse {
    self.isSuccess = isSuccess
    self.message = message
    self.response = response
  }
  
  enum CodingKeys: String, CodingKey {
    case isSuccess = "is_success"
    case message
    case response
  }
}
