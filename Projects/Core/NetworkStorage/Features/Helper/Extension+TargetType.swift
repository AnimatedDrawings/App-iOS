// //
// //  Extension+TargetType.swift
// //  NetworkStorage
// //
// //  Created by chminii on 3/11/24.
// //  Copyright 2024 chminipark. All rights reserved.
// //

import Foundation
import NetworkStorageInterfaces

extension TargetType {
  var baseURL: String {
    return Env.baseUrl
  }
}

extension TargetType {
  public var fullURL: URL {
    get throws {
      guard let url = URL(string: baseURL)?.appendingPathComponent(path)
      else {
        throw NetworkStorageError.makeFullURL
      }
      return url
    }
  }

  public func setHTTPMethod(
    urlRequest: URLRequest
  ) -> URLRequest {
    var tmpRequest = urlRequest

    tmpRequest.httpMethod = method.rawValue

    return tmpRequest
  }

  public func setBodyParameter(
    urlRequest: URLRequest
  ) throws -> URLRequest {
    var tmpRequest = urlRequest

    if let body = try bodyParameters {
      tmpRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      tmpRequest.httpBody = try JSONSerialization.data(withJSONObject: body)
    }

    return tmpRequest
  }

  public func setQueryParmeter(url: URL) throws -> URL {
    if let queryParameters = try queryParameters,
      !queryParameters.isEmpty
    {
      guard
        var components = URLComponents(
          url: url,
          resolvingAgainstBaseURL: false
        )
      else {
        throw NetworkStorageError.queryParameter
      }

      let stringValueQueryParams = queryParameters.toStringValue()
      components.queryItems = stringValueQueryParams.map {
        URLQueryItem(name: $0.key, value: $0.value)
      }

      guard let urlWithQuery = components.url else {
        throw NetworkStorageError.queryParameter
      }
      return urlWithQuery
    } else {
      return url
    }
  }

  public func setHeaderParameter(
    urlRequest: URLRequest
  ) -> URLRequest {
    var tmpRequest = urlRequest
    if let headers = headers {
      headers.forEach {
        tmpRequest.setValue($0.value, forHTTPHeaderField: $0.name)
      }
    }
    return tmpRequest
  }

  public var urlRequest: URLRequest {
    get throws {
      var url = try fullURL
      try url = setQueryParmeter(url: url)

      var urlRequest = URLRequest(url: url)
      urlRequest = try setBodyParameter(urlRequest: urlRequest)
      urlRequest = setHTTPMethod(urlRequest: urlRequest)

      return urlRequest
    }
  }
  
  public var webSocketURL: URL {
    get throws {
      guard let originalURL = try urlRequest.url else {
        throw NetworkStorageError.makeFullURL
      }
      
      var components = URLComponents(
        url: originalURL,
        resolvingAgainstBaseURL: false
      )
      
      if components?.scheme == "http" {
        components?.scheme = "ws"
      } else if components?.scheme == "https" {
        components?.scheme = "wss"
      }
      
      if let newURL = components?.url {
        return newURL
      } else {
        throw NetworkStorageError.makeFullURL
      }
    }
  }
}
