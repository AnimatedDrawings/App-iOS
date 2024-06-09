//
//  ExtensionTargetTypeTests.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import NetworkStorage
import NetworkStorageTestings

final class ExtensionTargetTypeTests: XCTestCase {
  var targetType: MockExtensionTargetType!
  
  override func setUp() {
    targetType = .requestPlain
  }
  
  func testFetchBaseURL() {
    let url = "https://miniiad.duckdns.org"
    XCTAssertEqual(targetType.baseURL, url)
  }
  
  func testGetURLRequestTaskRequestPlain() {
    targetType = .requestPlain
    
    guard let urlRequest = try? targetType.getUrlRequest() else {
      XCTFail()
      return
    }
    
    XCTAssertNil(urlRequest.httpBody)
    XCTAssertEqual(urlRequest.httpMethod, targetType.method.rawValue)
  }
  
  func testGetURLRequestTaskRequestJSONEncodable() {
    targetType = .requestJSONEncodable
    guard let uploadJson = try? JSONEncoder().encode(MockJsonObject()) else {
      XCTFail()
      return
    }
    let headerValue = "application/json"
    
    guard let urlRequest = try? targetType.getUrlRequest() else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(urlRequest.httpBody, uploadJson)
    XCTAssertEqual(urlRequest.httpMethod, targetType.method.rawValue)
    XCTAssertEqual(
      urlRequest.value(forHTTPHeaderField: "Content-Type"),
      headerValue
    )
  }
  
  func testGetURLRequestTaskUploadMultipart() {
    targetType = .uploadMultipart
    let uniqString: String = UUID().uuidString
    let uploadData = Data().convertUploadMultiPartData(uniqString: uniqString)
    let headerValue = "multipart/form-data; boundary=\(uniqString)"
    
    guard let urlRequest = try? targetType.getUrlRequest(uniqString: uniqString) else {
      XCTFail()
      return
    }
    
    XCTAssertEqual(urlRequest.httpBody, uploadData)
    XCTAssertEqual(urlRequest.httpMethod, targetType.method.rawValue)
    XCTAssertEqual(
      urlRequest.value(forHTTPHeaderField: "Content-Type"),
      headerValue
    )
  }
  
  func testMakeURL() {
    XCTAssertNoThrow(try targetType.url())
  }
  
  func testMakeURLComponentsSuccess() {
    let mockQueryItems = targetType.queryParameters!.map { (key, value) in
      URLQueryItem(name: key, value: value)
    }
    let mockQueryItemsSet = Set(mockQueryItems)
    
    guard let urlComponents = try? targetType.makeURLComponents(),
          let scheme = urlComponents.scheme,
          let host = urlComponents.host,
          let queryItems = urlComponents.queryItems
    else {
      XCTFail()
      return
    }
    let resultBaseURL = scheme + "://" + host
    let resultQueryItemsSet = Set(queryItems)
    
    XCTAssertEqual(resultBaseURL, targetType.baseURL)
    XCTAssertEqual(urlComponents.path, targetType.path)
    XCTAssertEqual(resultQueryItemsSet, mockQueryItemsSet)
  }
}
