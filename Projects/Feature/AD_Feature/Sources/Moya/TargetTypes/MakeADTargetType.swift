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
  
  case step2FindTheCharacter(request: FindTheCharacterRequest)
  case step2DownloadMaskImage(ad_id: String)
  
  case step3SeparateCharacter(request: SeparateCharacterRequest)
}

fileprivate let makeADPath: String = "/api/make_ad/"

extension MakeADTargetType: TargetType {
  var baseURL: URL { URL(string: "https://miniiad.duckdns.org")! }
  
  var path: String {
    switch self {
    case .step1UploadDrawing:
      return makeADPath + "step1/upload_a_drawing"
      
    case .step2FindTheCharacter(let request):
      return makeADPath + "step2/find_the_character/\(request.ad_id)"
    case .step2DownloadMaskImage(let ad_id):
      return makeADPath + "step2/download_mask_image/\(ad_id)"
      
    case .step3SeparateCharacter(let request):
      return makeADPath + "step3/separate_character/\(request.ad_id)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .step1UploadDrawing:
      return .post
      
    case .step2FindTheCharacter:
      return .post
    case .step2DownloadMaskImage:
      return .get
      
    case .step3SeparateCharacter:
      return .post
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case .step1UploadDrawing:
      return ["Content-type" : "multipart/form-data"]
      
    case .step2FindTheCharacter:
      return ["Content-type" : "application/json"]
    case .step2DownloadMaskImage:
      return .none
      
    case .step3SeparateCharacter:
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
      
    case .step2FindTheCharacter(let request):
      return .requestJSONEncodable(request.boundingBoxDTO)
    case .step2DownloadMaskImage:
      return .requestPlain
      
    case .step3SeparateCharacter(let request):
      let imageData = MultipartFormData(
        provider: .data(request.maskedImageData),
        name: "file",
        fileName: "tmp",
        mimeType: request.maskedImageData.mimeType
      )
      
      return .uploadMultipart([imageData])
    }
  }
}
