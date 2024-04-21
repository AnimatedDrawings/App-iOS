//
//  MockResponse.swift
//  NetworkStorage
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces

public struct MockResponse: Codable, Equatable {
  public init() {}
}

public extension DefaultResponse {
  func toJsonData() -> Data? {
    return try? JSONEncoder().encode(self)
  }
}
