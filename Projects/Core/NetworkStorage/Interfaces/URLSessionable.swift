//
//  URLSessionable.swift
//  NetworkStorageInterfaces
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public protocol URLSessionable {
  func data(
    for request: URLRequest,
    delegate: (URLSessionTaskDelegate)?
  ) async throws -> (Data, URLResponse)
}
