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
  private var mockURLSession: MockURLSesson!
  private var mockNetworkStorage: NetworkStorage<MockTargetType>!
  
  override func setUp() {
    super.setUp()
    
    mockURLSession = MockURLSesson(responseData: Data())
    mockNetworkStorage = NetworkStorage<MockTargetType>(
      session: mockURLSession
    )
  }
  
  func testNetworkStorageRequestEmptyResponse() async throws {
    mockURLSession.responseData = .mockEmptyResponseData
    
    let emptyResponse: EmptyResponse = try await mockNetworkStorage.request(.requestEmptyResponse)
    XCTAssertNoThrow(emptyResponse)
  }
  
  func testNetworkStorageRequestDefaultResponse() async throws {
    mockURLSession.responseData = .mockDefaultResponseData
    
    let mockResponse: MockResponse = try await mockNetworkStorage.request(.requestDefaultResponse)
    XCTAssertNoThrow(mockResponse)
    XCTAssertEqual(mockResponse.test, "test")
  }
  
  func testNetworkStorageDownload() async throws {
    let emptyData = Data()
    
    mockURLSession.responseData = emptyData
    
    let responseData = try await mockNetworkStorage.download(.download)
    XCTAssertEqual(emptyData, responseData)
  }
}


// MARK: - MockResponse

fileprivate struct MockResponse: Responsable {
  let test: String
}


// MARK: - ResponseData

fileprivate extension Data {
  static var mockEmptyResponseData: Self {
    return """
{
"is_success" : true,
"message" : "test",
"response" : {}
}
""".data(using: .utf8)!
  }
  
  static var mockDefaultResponseData: Self {
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
}


// MARK: - MockURLSesson

fileprivate class MockURLSesson: URLSessionable {
  var responseData: Data
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
