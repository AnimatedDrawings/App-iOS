//
//  DefaultResponse.swift
//  AD_Feature
//
//  Created by minii on 2023/08/07.
//  Copyright © 2023 chminipark. All rights reserved.
//

import NetworkStorageInterfaces

public struct EmptyResponse: Responsable, Equatable {}

public struct DefaultResponse<R: Responsable>: Codable {
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
