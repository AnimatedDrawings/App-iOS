//
//  MakeADTargetType.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

enum MakeADTargetType {
  case uploadDrawing(UploadADrawingRequest)
  
  case findTheCharacter(FindTheCharacterRequest)
  case downloadMaskImage(DownloadMaskImageRequest)
  
  case separateCharacter(SeparateCharacterRequest)
  
  case findCharacterJoints(FindCharacterJointsRequest)
}

fileprivate let makeADPath: String = "/api/make_ad/"

extension MakeADTargetType: TargetType {
  var path: String {
    switch self {
    case .uploadDrawing:
      return makeADPath + "step1/upload_a_drawing"
      
    case .findTheCharacter(let request):
      return makeADPath + "step2/find_the_character/\(request.ad_id)"
    case .downloadMaskImage(let request):
      return makeADPath + "step2/download_mask_image/\(request.ad_id)"
      
    case .separateCharacter(let request):
      return makeADPath + "step3/separate_character/\(request.ad_id)"
      
    case .findCharacterJoints(let request):
      return makeADPath + "step4/find_character_joints/\(request.ad_id)"
    }
  }
  
  var method: HttpMethod {
    switch self {
    case .uploadDrawing:
      return .post
      
    case .findTheCharacter:
      return .post
    case .downloadMaskImage:
      return .get
      
    case .separateCharacter:
      return .post
      
    case .findCharacterJoints:
      return .post
    }
  }
  
  var queryParameters: [String : String]? {
    return nil
  }
  
  var task: NetworkTask {
    switch self {
    case .uploadDrawing(let uploadADrawingRequest):
      return .uploadMultipart(uploadADrawingRequest.convertedPNG)
      
    case .findTheCharacter(let findTheCharacterRequest):
      return .requestJSONEncodable(findTheCharacterRequest.boundingBoxDTO)
    case .downloadMaskImage:
      return .requestPlain
      
    case .separateCharacter(let separateCharacterRequest):
      return .uploadMultipart(separateCharacterRequest.maskedImageData)
      
    case .findCharacterJoints(let findCharacterJointsRequest):
      return .requestJSONEncodable(findCharacterJointsRequest.jointsDTO)
    }
  }
}


//public extension Data {
//  var mimeType: String {
//    var b: UInt8 = 0
//    self.copyBytes(to: &b, count: 1)
//
//    switch b {
//    case 0xFF:
//      return "image/jpeg"
//    case 0x89:
//      return "image/png"
//    case 0x47:
//      return "image/gif"
//    case 0x4D, 0x49:
//      return "image/tiff"
//    case 0x25:
//      return "application/pdf"
//    case 0xD0:
//      return "application/vnd"
//    case 0x46:
//      return "text/plain"
//    default:
//      return "application/octet-stream"
//    }
//  }
//}
