//
//  MockResponseData.swift
//  NetworkStorage
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces

struct MockResponse: Responsable {
  let test: String
}

extension Data {
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
