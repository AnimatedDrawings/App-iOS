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
    
    jsonObject = MockJsonObject()
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


// MARK: - MockJsonObject

fileprivate struct MockJsonObject: Encodable {
  let test = "test"
}


// MARK: - MockTargetType

fileprivate enum MockTargetType {
  case requestJSONEncodable(Encodable)
  case uploadMultipart(String, Data)
}

extension MockTargetType: TargetType {
  var baseURL: String {
    return "baseURL"
  }
  
  var path: String {
    return "path"
  }
  
  var method: HttpMethod {
    switch self {
    case .requestJSONEncodable:
      return .get
    case .uploadMultipart:
      return .post
    }
  }
  
  var queryParameters: [String : String]? {
    switch self {
    case .requestJSONEncodable:
      return ["requestJSONEncodable" : "requestJSONEncodable"]
    case .uploadMultipart:
      return ["uploadMultipart" : "uploadMultipart"]
    }
  }
  
  var task: NetworkTask {
    switch self {
    case .requestJSONEncodable(let jsonObject):
      return .requestJSONEncodable(jsonObject)
    case let .uploadMultipart(_, uploadData):
      return .uploadMultipart(uploadData)
    }
  }
}

extension MockTargetType {
  var mockHttpBody: Data {
    get throws {
      switch self {
      case .requestJSONEncodable(let jsonObject):
        return try JSONEncoder().encode(jsonObject)
      case let .uploadMultipart(uniqString, uploadData):
        return uploadData.convertUploadMultiPartData(uniqString: uniqString)
      }
    }
  }
  
  var mockHttpMethod: String {
    switch self {
    case .requestJSONEncodable:
      return HttpMethod.get.rawValue
    case .uploadMultipart:
      return HttpMethod.post.rawValue
    }
  }
  
  var mockHeader: [String : String] {
    switch self {
    case .requestJSONEncodable:
      return ["Content-Type" : "application/json"]
    case let .uploadMultipart(uniqString, _):
      return ["Content-Type" : "multipart/form-data; boundary=\(uniqString)"]
    }
  }
}
