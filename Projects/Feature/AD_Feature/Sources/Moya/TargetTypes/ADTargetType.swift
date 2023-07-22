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
  
  case imageToAnnotations(
    maskedImage: Data,
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
    case .imageToAnnotations:
      return makeADPath + "image_to_annotations"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .uploadImage:
      return .post
    case .imageToAnnotations:
      return .post
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .uploadImage:
      return ["Content-type" : "multipart/form-data"]
    case .imageToAnnotations:
      return ["Content-type" : "multipart/form-data"]
    default:
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
      
    case let .imageToAnnotations(maskedImage, name, fileName, mimeType):
      let imageData = MultipartFormData(
        provider: .data(maskedImage),
        name: name,
        fileName: fileName,
        mimeType: mimeType
      )
      
      return .uploadMultipart([imageData])
    }
  }
}
