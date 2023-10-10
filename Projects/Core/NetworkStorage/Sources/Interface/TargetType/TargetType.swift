//
//  TargetType.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

protocol TargetType {
  var baseURL: String { get }
  var path: String { get }
  var method: HttpMethod { get }
  var queryParameters: [String : String]? { get }
  var headers: [String: String]? { get }
  var task: NetworkTask { get }
}

extension TargetType {
  var uploadData: Data? { nil }
  
  func getUrlRequest() throws -> URLRequest {
    let url = try url()
    var urlRequest = URLRequest(url: url)
    
    // httpBody
    var httpBody: Data?
    switch task {
    case .requestPlain:
      httpBody = nil
    case .requestJSONEncodable(let jsonObject):
      guard let bodyData = try? JSONSerialization.data(withJSONObject: jsonObject) else {
        throw NetworkError.requestJSONEncodable
      }
      httpBody = bodyData
    case .uploadMultipart(let imageData):
      var body = Data()
      let uniqString = UUID().uuidString
      body.append("--\(uniqString)\r\n".data(using: .utf8)!)
      body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
      body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
      body.append(imageData)
      body.append("\r\n".data(using: .utf8)!)
      body.append("--\(uniqString)--\r\n".data(using: .utf8)!)
      httpBody = body
    }
    
    if let httpBody = httpBody {
      urlRequest.httpBody = httpBody
    }

    // httpMethod
    urlRequest.httpMethod = method.rawValue
    
    // header
    headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }
    
    return urlRequest
  }
  
  func url() throws -> URL {
    // baseURL + path
    let fullPath = "\(baseURL)\(path)"
    guard var urlComponents = URLComponents(string: fullPath) else { throw NetworkError.makeUrlComponent }
    
    // (baseURL + path) + queryParameters
    var urlQueryItems = [URLQueryItem]()
    if let queryParameters = queryParameters {
      queryParameters.forEach { key, value in
        urlQueryItems.append(URLQueryItem(name: key, value: value))
      }
    }
    urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
    
    guard let url = urlComponents.url else { throw NetworkError.makeURL }
    return url
  }
}
