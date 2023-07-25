//
//  ADAPI.swift
//  AD_Feature
//
//  Created by minii on 2023/06/27.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import Moya

let providerMakeAD = MoyaProvider<MakeADTargetType>()

enum MakeADTargetType {
  case step1UploadDrawing(
    imageData: Data,
    name: String,
    fileName: String,
    mimeType: String
  )
  
  case step3ImageToAnnotations(
    maskedImage: Data,
    name: String,
    fileName: String,
    mimeType: String
  )
}

fileprivate let makeADPath: String = "/api/make_ad/"

extension MakeADTargetType: TargetType {
  var baseURL: URL { URL(string: "https://miniiad.duckdns.org")! }
  
  var path: String {
    switch self {
    case .step1UploadDrawing:
      return makeADPath + "step1/upload_drawing"
    case .step3ImageToAnnotations:
      return makeADPath + "step3/image_to_annotations"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .step1UploadDrawing:
      return .post
    case .step3ImageToAnnotations:
      return .post
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .step1UploadDrawing:
      return ["Content-type" : "multipart/form-data"]
    case .step3ImageToAnnotations:
      return ["Content-type" : "multipart/form-data"]
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .step1UploadDrawing(data, name, fileName, mimeType):
      let imageData = MultipartFormData(
        provider: .data(data),
        name: name,
        fileName: fileName,
        mimeType: mimeType
      )

      return .uploadMultipart([imageData])
      
    case let .step3ImageToAnnotations(maskedImage, name, fileName, mimeType):
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
