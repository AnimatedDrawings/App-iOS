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

struct Asserter<T> {
  func generic(_ val: Any) -> Bool {
    let type = type(of: val)
    return T.self == type
  }
}

class NetworkStorage<T: TargetType> {
  let session: URLSessionable
  
  init(session: URLSessionable = URLSession.shared) {
    self.session = session
  }
  
  func request<R: Responsable>(_ target: T) async throws -> R {
    let urlRequest = try target.getUrlRequest()
    let (data, urlResponse) = try await session.data(for: urlRequest, delegate: nil)
    
    guard let decoded = try? JSONDecoder().decode(DefaultResponse<R>.self, from: data) else {
//      throw NetworkError.convertResponseModel
      throw NetworkError.ADServerError
    }
    
    guard decoded.isSuccess else {
      throw NetworkError.ADServerError
    }
    
    if Asserter<R>().generic(EmptyResponse()) {
      return EmptyResponse() as! R
    }
    
    guard let responseModel = decoded.response else {
//      throw NetworkError.emptyResponse
      throw NetworkError.ADServerError
    }
    return responseModel
  }
  
  func download(_ target: T) async throws -> Data {
    let urlRequest = try target.getUrlRequest()
    let (data, urlResponse) = try await session.data(for: urlRequest, delegate: nil)
    return data
  }
}
