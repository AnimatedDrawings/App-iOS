//
//  NetworkStorage.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces
import ADErrors
import CoreModels

public class NetworkStorage<T: TargetType> {
  let session: URLSessionable
  
  public init(session: URLSessionable = URLSession.shared) {
    self.session = session
  }
  
  public func request<R: Codable>(_ target: T) async throws -> R {
    let urlRequest = try target.getUrlRequest()
    let (data, _) = try await session.data(for: urlRequest, delegate: nil)
    
    guard let decoded = try? JSONDecoder().decode(DefaultResponse<R>.self, from: data) else {
      throw NetworkStorageError.jsonDecode
    }
    
    guard decoded.isSuccess else {
      throw NetworkStorageError.server
    }
    
    if Asserter<R>().generic(EmptyResponse()) {
      return EmptyResponse() as! R
    }
    
    guard let responseModel = decoded.response else {
      throw NetworkStorageError.emptyResponse
    }
    return responseModel
  }
  
  public func download(_ target: T) async throws -> Data {
    let urlRequest = try target.getUrlRequest()
    let (data, _) = try await session.data(for: urlRequest, delegate: nil)
    return data
  }
}
