//
//  MakeADTargetType.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation
import NetworkStorageInterfaces
import CoreModels

enum MakeADTargetType {
  case uploadDrawing(UploadDrawingRequest)
  
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
