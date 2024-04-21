//
//  MockURLSesson.swift
//  NetworkStorage
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import NetworkStorageInterfaces
import Foundation

public class MockURLSesson: URLSessionable {
  let mockData: Data
  
  public init(responseJsonData: Data) {
    self.mockData = responseJsonData
  }
  
  public func data(
    for request: URLRequest,
    delegate: (any URLSessionTaskDelegate)?)
  async throws -> (Data, URLResponse)
  {
    return (mockData, URLResponse())
  }
}
