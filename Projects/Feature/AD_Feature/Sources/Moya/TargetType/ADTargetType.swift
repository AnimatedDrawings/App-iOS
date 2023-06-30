//
//  ADAPI.swift
//  AD_Feature
//
//  Created by minii on 2023/06/27.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import Moya

let providerAD = MoyaProvider<ADTargetType>()

enum ADTargetType {
  case uploadImage(
    data: Data,
    name: String,
    fileName: String,
    mimeType: String
  )
}

fileprivate let makeADPath: String = "/api/makeAD/"

extension ADTargetType: TargetType {
  var baseURL: URL { URL(string: "https://miniiad.duckdns.org")! }
  
  var path: String {
    switch self {
    case .uploadImage:
      return makeADPath + "upload_image"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .uploadImage:
      return .post
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .uploadImage:
      return ["Content-type" : "multipart/form-data"]
    default:
//      return ["Content-type" : "application/json"]
      return nil
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .uploadImage(data, name, fileName, mimeType):
      let imageData = MultipartFormData(
        provider: .data(data),
        name: name,
        fileName: fileName,
        mimeType: mimeType
      )

      return .uploadMultipart([imageData])
    }
  }
}
