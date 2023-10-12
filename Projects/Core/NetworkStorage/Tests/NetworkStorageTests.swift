//
//  NetworkStorageTests.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import NetworkStorage

final class NetworkStorageTests: XCTestCase {
  func testNetworkStorageRequestEmptyResponse() async throws {
    let mockNetworkStorage = NetworkStorage<MockTargetType>(
      session: MockURLSesson(responseData: mockEmptyResponseData)
    )
    
    let emptyResponse: EmptyResponse = try await mockNetworkStorage.request(.requestEmptyResponse)
    XCTAssertNoThrow(emptyResponse)
  }
  
  func testNetworkStorageRequestDefaultResponse() async throws {
    let mockNetworkStorage = NetworkStorage<MockTargetType>(
      session: MockURLSesson(responseData: mockDefaultResponseData)
    )
    
    let mockResponse: MockResponse = try await mockNetworkStorage.request(.requestDefaultResponse)
    XCTAssertNoThrow(mockResponse)
    XCTAssertEqual(mockResponse.test, "test")
  }
  
  func testNetworkStorageDownload() async throws {
    let emptyData = Data()
    let mockNetworkStorage = NetworkStorage<MockTargetType>(
      session: MockURLSesson(responseData: emptyData)
    )
    
    let responseData = try await mockNetworkStorage.download(.download)
    XCTAssertEqual(emptyData, responseData)
  }
}


// MARK: - MockResponse

fileprivate struct MockResponse: Responsable {
  let test: String
}


// MARK: - ResponseData

fileprivate var mockEmptyResponseData: Data {
  return """
{
"is_success" : true,
"message" : "test",
"response" : {}
}
""".data(using: .utf8)!
}

fileprivate var mockDefaultResponseData: Data {
  return """
{
"is_success" : true,
"message" : "test",
"response" : {
  "test" : "test"
}
}
""".data(using: .utf8)!
}


// MARK: - MockURLSesson

fileprivate class MockURLSesson: URLSessionable {
  let responseData: Data
  var result: Result<Data, Error> {
    return Result<Data, Error>.success(responseData)
  }
  
  init(responseData: Data) {
    self.responseData = responseData
  }
  
  func data(
    for request: URLRequest,
    delegate: (URLSessionTaskDelegate)?
  ) async throws -> (Data, URLResponse) {
    try (result.get(), URLResponse())
  }
}


// MARK: - MockTargetType

fileprivate enum MockTargetType {
  case requestEmptyResponse
  case requestDefaultResponse
  case download
}

extension MockTargetType: TargetType {
  var baseURL: String {
    return "baseURL"
  }
  
  var path: String {
    return "path"
  }
  
  var method: HttpMethod {
    return .get
  }
  
  var queryParameters: [String : String]? {
    return nil
  }
  
  var task: NetworkTask {
    return .requestPlain
  }
}
