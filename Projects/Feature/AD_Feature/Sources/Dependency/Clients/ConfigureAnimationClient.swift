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
import AD_Utils

struct ConfigureAnimationClient {
  var add: @Sendable (ConfigureAnimationRequest) async throws -> ConfigureAnimationResponse
  var downloadVideo: @Sendable (ConfigureAnimationRequest) async throws -> Data
}

extension ConfigureAnimationClient: DependencyKey {
  static let liveValue = Self(
    add: { request in
      let response = await providerConfigureAnimation.request(.add(request))
      switch response {
      case .success(let success):
        if let responseModel = try? JSONDecoder().decode(ConfigureAnimationResponse.self, from: success.data) {
          return responseModel
        }
        if let errorText = try? success.mapString() {
          print(errorText)
        }
        throw MoyaError.jsonMapping(success)
      case .failure(let failure):
        print(failure.localizedDescription)
        throw failure
      }
    },
    
    downloadVideo: { request in
      let response = await providerConfigureAnimation.request(.downloadVideo(request))
      switch response {
      case .success(let success):
        return success.data
//        if let errorText = try? success.mapString() {
//          print(errorText)
//        }
      case .failure(let failure):
        print(failure.localizedDescription)
        throw failure
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
