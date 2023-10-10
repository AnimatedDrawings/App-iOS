//
//  NetworkStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

protocol URLSessionable {
  func data(
    for request: URLRequest,
    delegate: (URLSessionTaskDelegate)?
  ) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionable {}

class NetworkStorage<T: TargetType> {
  let session: URLSessionable
  
  init(session: URLSessionable = URLSession.shared) {
    self.session = session
  }
  
  func request<R: Responsable>(_ target: T) async throws -> R {
    let urlRequest = try target.getUrlRequest()
    let (data, urlResponse) = try await session.data(for: urlRequest, delegate: nil)
  
    guard let decoded = try? JSONDecoder().decode(DefaultResponse<R>.self, from: data),
          let responseModel = decoded.response
    else {
      throw NetworkError.convertResponseModel
    }
    
    guard decoded.isSuccess else {
      throw NetworkError.ADServerError
    }
    
    return responseModel
  }
}
