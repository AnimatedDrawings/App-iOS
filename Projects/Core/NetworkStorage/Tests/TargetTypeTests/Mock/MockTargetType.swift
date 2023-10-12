//
//  TestTargetType.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
@testable import NetworkStorage

enum MockTargetType {
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
