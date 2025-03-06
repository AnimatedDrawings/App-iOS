//
//  ADTargetType.swift
//  NetworkStorage
//
//  Created by minii on 2023/10/10.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADAlamofire
import Foundation
import NetworkStorageInterfaces

enum ADTargetType: TargetType {
  case uploadDrawing(UploadDrawingRequest)
  case findCharacter(FindCharacterRequest)
  case cutoutCharacter(CutoutCharacterRequest)
  case configureCharacterJoints(ConfigureCharacterJointsRequest)
  case makeAnimation(MakeAnimationRequest)
}

extension ADTargetType {
  var path: String {
    switch self {
    case .uploadDrawing:
      return "upload_drawing"
    case .findCharacter:
      return "find_character"
    case .cutoutCharacter:
      return "cutout_character"
    case .configureCharacterJoints:
      return "configure_character_joints"
    case .makeAnimation:
      return "make_animation"
    }
  }

  var headers: HTTPHeaders? {
    switch self {
    case .uploadDrawing, .cutoutCharacter:
      return ["Content-Type": "multipart/form-data"]
    default:
      return nil
    }
  }

  var method: HTTPMethod {
    switch self {
    case .uploadDrawing,
      .findCharacter,
      .cutoutCharacter,
      .configureCharacterJoints,
      .makeAnimation:
      return .post
    }
  }

  var queryParameters: Parameters? {
    get throws {
      switch self {
      case .uploadDrawing:
        return nil
      case .findCharacter(let request):
        return ["ad_id": request.ad_id]
      case .cutoutCharacter(let request):
        return ["ad_id": request.ad_id]
      case .configureCharacterJoints(let request):
        return ["ad_id": request.ad_id]
      case .makeAnimation(let request):
        return try request.toDict()
      }
    }
  }

  var bodyParameters: Parameters? {
    get throws {
      switch self {
      case .uploadDrawing:
        return nil
      case .findCharacter(let request):
        return try request.boundingBoxDTO.toDict()
      case .cutoutCharacter:
        return nil
      case .configureCharacterJoints(let request):
        return try request.jointsDTO.toDict()
      case .makeAnimation:
        return nil
      }
    }
  }
}
