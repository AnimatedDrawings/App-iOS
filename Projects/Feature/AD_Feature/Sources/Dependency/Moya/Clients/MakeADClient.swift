//
//  MakeADClient.swift
//  AD_Feature
//
//  Created by minii on 2023/06/27.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Moya

struct MakeADClient {
  var step1UploadDrawing: @Sendable (UploadADrawingRequest) async throws -> UploadADrawingResposne
  
  var step2FindTheCharacter: @Sendable (FindTheCharacterRequest) async throws -> EmptyResponse
  var step2DownloadMaskImage: @Sendable (String) async throws -> UIImage
  
  var step3SeparateCharacter: @Sendable (SeparateCharacterRequest) async throws -> SeparateCharacterReponse
  
  var step4findCharacterJoints: @Sendable (FindCharacterJointsRequest) async throws -> EmptyResponse
}

extension MakeADClient: DependencyKey {
  static let liveValue = Self(
    step1UploadDrawing: { request in
      let response = await providerMakeAD.request(.step1UploadDrawing(request))
      switch response {
      case .success(let success):
        guard let responseModel = try? JSONDecoder()
          .decode(DefaultResponse<UploadADrawingResposne>.self, from: success.data)
        else {
          throw ADMoyaError.jsonMapping
        }
        guard responseModel.isSuccess,
              let responseModel = responseModel.response
        else {
          print(responseModel.message)
          throw ADMoyaError.calculateInServer
        }
        return responseModel
      case .failure(let failure):
        print(failure.localizedDescription)
        throw ADMoyaError.connection
      }
    },
    
    
    step2FindTheCharacter: { request in
      let response = await providerMakeAD.request(.step2FindTheCharacter(request))
      switch response {
      case .success(let success):
        guard let responseModel = try? JSONDecoder()
          .decode(EmptyResponseType.self, from: success.data)
        else {
          throw ADMoyaError.jsonMapping
        }
        guard responseModel.isSuccess else {
          print(responseModel.message)
          throw ADMoyaError.calculateInServer
        }
        return EmptyResponse()
      case .failure(let failure):
        print(failure.localizedDescription)
        throw ADMoyaError.connection
      }
    },
    
    step2DownloadMaskImage: { ad_id in
      let response = await providerMakeAD.request(.step2DownloadMaskImage(ad_id: ad_id))
      switch response {
      case .success(let success):
        guard let maskImage = UIImage(data: success.data) else {
          throw ADMoyaError.imageMapping
        }
        return maskImage
        
      case .failure(let failure):
        print(failure.localizedDescription)
        throw ADMoyaError.connection
      }
    },
    
    
    step3SeparateCharacter: { request in
      let response = await providerMakeAD.request(.step3SeparateCharacter(request))
      switch response {
      case .success(let success):
        guard let responseModel = try? JSONDecoder()
          .decode(DefaultResponse<SeparateCharacterReponse>.self, from: success.data)
        else {
          throw ADMoyaError.jsonMapping
        }
        guard responseModel.isSuccess,
              let responseModel = responseModel.response
        else {
          print(responseModel.message)
          throw ADMoyaError.calculateInServer
        }
        return responseModel
      case .failure(let failure):
        print(failure.localizedDescription)
        throw ADMoyaError.connection
      }
    },
    
    step4findCharacterJoints: { request in
      let response = await providerMakeAD.request(.step4findCharacterJoints(request))
      switch response {
      case .success(let success):
        guard let responseModel = try? JSONDecoder()
          .decode(EmptyResponseType.self, from: success.data)
        else {
          throw ADMoyaError.jsonMapping
        }
        guard responseModel.isSuccess else {
          print(responseModel.message)
          throw ADMoyaError.calculateInServer
        }
        return EmptyResponse()
      case .failure(let failure):
        print(failure.localizedDescription)
        throw ADMoyaError.connection
      }
    }
  )
  
  static let testValue = Self(
    step1UploadDrawing: unimplemented("\(Self.self) testValue of search"),
    step2FindTheCharacter: unimplemented("\(Self.self) testValue of search"),
    step2DownloadMaskImage: unimplemented("\(Self.self) testValue of search"),
    step3SeparateCharacter: unimplemented("\(Self.self) testValue of search"),
    step4findCharacterJoints: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var makeADClient: MakeADClient {
    get { self[MakeADClient.self] }
    set { self[MakeADClient.self] = newValue }
  }
}
