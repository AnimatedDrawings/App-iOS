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
  var task: NetworkTask { get }
}

extension Data {
  func convertUploadMultiPartData(uniqString: String) -> Data {
    var body = Data()
    body.append("--\(uniqString)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"file\"; filename=\"file\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    body.append(self)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(uniqString)--\r\n".data(using: .utf8)!)
    return body
  }
}

extension TargetType {
  var baseURL: String { "https://miniiad.duckdns.org" }
  
  func getUrlRequest(uniqString: String = UUID().uuidString) throws -> URLRequest {
    let url = try url()
    var urlRequest = URLRequest(url: url)
    
    // httpBody
    var httpBody: Data?
    switch task {
    case .requestPlain:
      httpBody = nil
    case .requestJSONEncodable(let jsonObject):
      guard let body = try? JSONEncoder().encode(jsonObject) else {
        throw NetworkError.requestJSONEncodable
      }
      httpBody = body
    case .uploadMultipart(let imageData):
      httpBody = imageData.convertUploadMultiPartData(uniqString: uniqString)
    }
    
    if let httpBody = httpBody {
      urlRequest.httpBody = httpBody
    }

    // httpMethod
    urlRequest.httpMethod = method.rawValue
    
    // header
    switch task {
    case .requestJSONEncodable:
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
    case .uploadMultipart:
      urlRequest.setValue("multipart/form-data; boundary=\(uniqString)", forHTTPHeaderField: "Content-Type")
    default:
      break
    }
    
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
