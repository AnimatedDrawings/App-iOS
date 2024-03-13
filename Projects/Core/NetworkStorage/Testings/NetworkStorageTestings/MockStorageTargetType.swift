//
//  MockStorageTargetType.swift
//  NetworkStorage
//
//  Created by chminii on 3/13/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import NetworkStorageInterfaces

public enum MockStorageTargetType {
  case test
}

extension MockStorageTargetType: TargetType {
  public var baseURL: String {
    return "https://baseURL"
  }
  
  public var path: String {
    return "/path"
  }
  
  public var method: HttpMethod {
    return .get
  }
  
  public var queryParameters: [String : String]? {
    return [
      "query1" : "query1",
      "query2" : "query2",
    ]
  }
  
  public var task: NetworkTask {
    return .requestPlain
  }
}
