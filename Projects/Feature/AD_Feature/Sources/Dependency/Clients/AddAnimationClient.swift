//
//  AddAnimationClient.swift
//  AD_Feature
//
//  Created by minii on 2023/08/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Moya
import AD_Utils

struct AddAnimationClient {
  var addAnimation: @Sendable (AddAnimationRequest) async throws -> AddAnimationResponse
}

extension AddAnimationClient: DependencyKey {
  static let liveValue = Self(
    addAnimation: { request in
      let response = await providerAddAnimation.request(.addAnimation(request))
      switch response {
      case .success(let success):
        if let responseModel = try? JSONDecoder().decode(AddAnimationResponse.self, from: success.data) {
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
    }
  )
  
  static let testValue = Self(
    addAnimation: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var addAnimationClient: AddAnimationClient {
    get { self[AddAnimationClient.self] }
    set { self[AddAnimationClient.self] = newValue }
  }
}
