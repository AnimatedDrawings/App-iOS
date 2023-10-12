//
//  NetworkStorageTests.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import XCTest
@testable import NetworkStorage

enum TestTargetType {
  case getResponse
  case getEmptyResponse
}

struct JSONObejct: Encodable {
  let test = "test"
}

extension TestTargetType: TargetType {
  var baseURL: String {
    return "baseURL"
  }
  
  var path: String {
    return "path"
  }
  
  var method: HttpMethod {
    switch self {
    case .getResponse:
      return .get
    case .getEmptyResponse:
      return .post
    }
  }
  
  var queryParameters: [String : String]? {
    switch self {
    case .getResponse:
      return ["getResponse" : "getResponse"]
    case .getEmptyResponse:
      return ["getEmptyResponse" : "getEmptyResponse"]
    }
  }
  
  var task: NetworkTask {
    switch self {
    case .getResponse:
      return .uploadMultipart(Data())
    case .getEmptyResponse:
      return .requestJSONEncodable(JSONObejct())
    }
  }
}

final class TargetTypeTests: XCTestCase {
  func testMakeURL() throws {
    let testTargetType: TestTargetType = .getResponse
    let url = try testTargetType.url()
    XCTAssertEqual(url.absoluteString, "baseURLpath?getResponse=getResponse")
  }
}
