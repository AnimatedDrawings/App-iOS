//
//  ADClient.swift
//  AD_Feature
//
//  Created by minii on 2023/06/27.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Moya
import AD_Utils

struct MakeADClient {
  var step1UploadDrawing: @Sendable (UploadADrawingRequest) async throws -> UploadADrawingResposne
  var step2FindTheCharacter: @Sendable (FindTheCharacterRequest) async throws -> FindTheCharacterResponse
  var step2DownloadMaskImage: @Sendable (String) async throws -> UIImage
  var step3SeparateCharacter: @Sendable (SeparateCharacterRequest) async throws -> SeparateCharacterReponse
}

extension MakeADClient: DependencyKey {
  static let liveValue = Self(
    step1UploadDrawing: { request in
      let response = await providerMakeAD.request(.step1UploadDrawing(request))
      switch response {
      case .success(let success):
        guard let responseModel = try? JSONDecoder().decode(UploadADrawingResposne.self, from: success.data) else {
          throw MoyaError.jsonMapping(success)
        }
        return responseModel
      case .failure(let failure):
        print(failure.localizedDescription)
        throw failure
      }
    },
    
    step2FindTheCharacter: { request in
      let response = await providerMakeAD.request(.step2FindTheCharacter(request))
      switch response {
      case .success(let success):
        guard let responseModel = try? JSONDecoder().decode(FindTheCharacterResponse.self, from: success.data) else {
          throw MoyaError.jsonMapping(success)
        }
        return responseModel
      case .failure(let failure):
        print(failure.localizedDescription)
        throw failure
      }
    },
    
    step2DownloadMaskImage: { ad_id in
      let response = await providerMakeAD.request(.step2DownloadMaskImage(ad_id: ad_id))
      switch response {
      case .success(let success):
        guard let maskImage = UIImage(data: success.data) else {
          throw MoyaError.imageMapping(success)
        }
        return maskImage
        
      case .failure(let failure):
        print(failure.localizedDescription)
        throw failure
      }
    },
    
    
    step3SeparateCharacter: { request in
      let response = await providerMakeAD.request(.step3SeparateCharacter(request))
      switch response {
      case .success(let success):
        if let jointsDTO = try? JSONDecoder().decode(JointsDTO.self, from: success.data) {
          let separateCharacterReponse = SeparateCharacterReponse(jointsDTO: jointsDTO)
          return separateCharacterReponse
        }
        if let errorText = try? success.mapString() {
          print(errorText)
        }
        throw MoyaError.jsonMapping(success)
      case .failure(let failure):
        print(failure.localizedDescription)
        throw failure
      }
    }
  )
  
  static let testValue = Self(
    step1UploadDrawing: unimplemented("\(Self.self) testValue of search"),
    step2FindTheCharacter: unimplemented("\(Self.self) testValue of search"),
    step2DownloadMaskImage: unimplemented("\(Self.self) testValue of search"),
    step3SeparateCharacter: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var makeADClient: MakeADClient {
    get { self[MakeADClient.self] }
    set { self[MakeADClient.self] = newValue }
  }
}
