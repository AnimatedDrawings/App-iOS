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
  case step1UploadDrawing(UploadADrawingRequest)
  
  case step2FindTheCharacter(FindTheCharacterRequest)
  case step2DownloadMaskImage(ad_id: String)
  
  case step3SeparateCharacter(SeparateCharacterRequest)
  
  case step4findCharacterJoints(FindCharacterJointsRequest)
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
      
    case .step4findCharacterJoints(let request):
      return makeADPath + "step4/find_character_joints/\(request.ad_id)"
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
      
    case .step4findCharacterJoints:
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
      
    case .step4findCharacterJoints:
      return ["Content-type" : "application/json"]
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .step1UploadDrawing(let request):
      let imageData = MultipartFormData(
        provider: .data(request.originalImageData),
        name: "file",
        fileName: "tmp",
        mimeType: request.originalImageData.mimeType
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
      
    case .step4findCharacterJoints(let request):
      return .requestJSONEncodable(request.jointsDTO)
    }
  }
}

public extension Data {
  var mimeType: String {
    var b: UInt8 = 0
    self.copyBytes(to: &b, count: 1)
    
    switch b {
    case 0xFF:
      return "image/jpeg"
    case 0x89:
      return "image/png"
    case 0x47:
      return "image/gif"
    case 0x4D, 0x49:
      return "image/tiff"
    case 0x25:
      return "application/pdf"
    case 0xD0:
      return "application/vnd"
    case 0x46:
      return "text/plain"
    default:
      return "application/octet-stream"
    }
  }
}
