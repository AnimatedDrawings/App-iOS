//
//  TargetType.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADAlamofire
import Foundation

public protocol TargetType {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: HTTPHeaders? { get }
  var queryParameters: Parameters? { get throws }
  var bodyParameters: Parameters? { get throws }
}
