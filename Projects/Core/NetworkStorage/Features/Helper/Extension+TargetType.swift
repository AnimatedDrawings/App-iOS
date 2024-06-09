//
//  Extension+TargetType.swift
//  NetworkStorage
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces
import ADErrors

extension TargetType {
//  var baseURL: String { "https://miniiad.duckdns.org" }
  var baseURL: String {
    return Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
  }
  
  public func getUrlRequest(uniqString: String = UUID().uuidString) throws -> URLRequest {
    let url = try url()
    var urlRequest = URLRequest(url: url)
    
    var httpBody: Data?
    switch task {
    case .requestPlain:
      httpBody = nil
    case .requestJSONEncodable(let jsonObject):
      guard let body = try? JSONEncoder().encode(jsonObject) else {
        throw TargetTypeError.requestJSONEncodable
      }
      httpBody = body
    case .uploadMultipart(let imageData):
      httpBody = imageData.convertUploadMultiPartData(uniqString: uniqString)
    }
    
    if let httpBody = httpBody {
      urlRequest.httpBody = httpBody
    }

    urlRequest.httpMethod = method.rawValue
    
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
  
  public func url() throws -> URL {
    let urlComponenets = try makeURLComponents()
    guard let url = urlComponenets.url else {
      throw TargetTypeError.makeURL
    }
    return url
  }
  
  func makeURLComponents() throws -> URLComponents {
    let fullPath = "\(baseURL)\(path)"
    guard var urlComponents = URLComponents(string: fullPath) else { throw TargetTypeError.makeUrlComponent }
    
    var urlQueryItems = [URLQueryItem]()
    if let queryParameters = queryParameters {
      queryParameters.forEach { key, value in
        urlQueryItems.append(URLQueryItem(name: key, value: value))
      }
    }
    urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
    
    return urlComponents
  }
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
