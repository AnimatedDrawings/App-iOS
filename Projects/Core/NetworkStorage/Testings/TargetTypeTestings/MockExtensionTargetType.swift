//
//  MockExtensionTargetType.swift
//  NetworkStorageTestings
//
//  Created by chminii on 3/12/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces

public enum MockExtensionTargetType {
  case requestPlain
  case requestJSONEncodable
  case uploadMultipart
}

extension MockExtensionTargetType: TargetType {
  public var baseURL: String {
//    return "https://baseURL"
    return Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
  }
  
  public var path: String {
    return "/path"
  }
  
  public var method: HttpMethod {
    switch self {
    case .requestPlain:
      return .get
    case .requestJSONEncodable:
      return .put
    case .uploadMultipart:
      return .put
    }
  }
  
  public var queryParameters: [String : String]? {
    return [
      "query1" : "query1",
      "query2" : "query2",
    ]
  }
  
  public var task: NetworkTask {
    switch self {
    case .requestPlain:
      return .requestPlain
    case .requestJSONEncodable:
      return .requestJSONEncodable(MockJsonObject())
    case .uploadMultipart:
      return .uploadMultipart(Data())
    }
  }
}
