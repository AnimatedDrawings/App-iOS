//
//  TargetType.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public protocol TargetType {
  var baseURL: String { get }
  var path: String { get }
  var method: HttpMethod { get }
  var queryParameters: [String : String]? { get }
  var task: NetworkTask { get }
}
