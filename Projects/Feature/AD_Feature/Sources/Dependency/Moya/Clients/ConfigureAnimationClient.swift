//
//  ConfigureAnimationClient.swift
//  AD_Feature
//
//  Created by minii on 2023/08/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Moya

struct ConfigureAnimationClient {
  var add: @Sendable (ConfigureAnimationRequest) async throws -> EmptyResponse
  var downloadVideo: @Sendable (ConfigureAnimationRequest) async throws -> Data
}

extension ConfigureAnimationClient: DependencyKey {
  static let liveValue = Self(
    add: { request in
      let response = await providerConfigureAnimation.request(.add(request))
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
    
    downloadVideo: { request in
      let response = await providerConfigureAnimation.request(.downloadVideo(request))
      switch response {
      case .success(let success):
        return success.data
      case .failure(let failure):
        print(failure.localizedDescription)
        throw ADMoyaError.connection
      }
    }
  )
  
  static let testValue = Self(
    add: unimplemented("\(Self.self) testValue of search"),
    downloadVideo: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var configureAnimationClient: ConfigureAnimationClient {
    get { self[ConfigureAnimationClient.self] }
    set { self[ConfigureAnimationClient.self] = newValue }
  }
}
