//
//  TargetTypeTests.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import NetworkStorage

final class TargetTypeTests: XCTestCase {
  var jsonObject: Encodable!
  var uploadData: Data!
  var uniqString: String!
  
  override func setUp() {
    super.setUp()
    
    jsonObject = MockJSONObejct()
    uploadData = Data()
    uniqString = UUID().uuidString
  }
  
  func testMakeURL() throws {
    let mockTargetType: MockTargetType = .requestJSONEncodable(jsonObject)
    let url = try mockTargetType.url()
    XCTAssertEqual(url.absoluteString, "baseURLpath?requestJSONEncodable=requestJSONEncodable")
  }
  
  func testNetworkTaskRequestJSONEncodable() throws {
    let mockTargetType: MockTargetType = .requestJSONEncodable(jsonObject)
    let urlRequest = try mockTargetType.getUrlRequest()
    
    XCTAssertEqual(urlRequest.httpBody, try mockTargetType.mockHttpBody)
    XCTAssertEqual(urlRequest.httpMethod, mockTargetType.mockHttpMethod)
    XCTAssertEqual(urlRequest.allHTTPHeaderFields, mockTargetType.mockHeader)
  }
  
  func testNetworkTestUploadMultipart() throws {
    let mockTargetType: MockTargetType = .uploadMultipart(uniqString, uploadData)
    let urlRequest = try mockTargetType.getUrlRequest(uniqString: uniqString)
    
    XCTAssertEqual(urlRequest.httpBody, try mockTargetType.mockHttpBody)
    XCTAssertEqual(urlRequest.httpMethod, mockTargetType.mockHttpMethod)
    XCTAssertEqual(urlRequest.allHTTPHeaderFields, mockTargetType.mockHeader)
  }
}
