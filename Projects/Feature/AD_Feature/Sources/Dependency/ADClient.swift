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

struct ADClient {
  var uploadImage: @Sendable (UIImage) async -> Bool?
}

extension ADClient: DependencyKey {
  static let liveValue = Self(
    uploadImage: { croppedImage in
      let result = await providerAD.request(.uploadImage(croppedImage: croppedImage))
      
      switch result {
      case .success(let success):
        return true
      case .failure(let failure):
        print(failure.localizedDescription)
        return false
      }
    }
  )
  
  static let testValue = Self(
    uploadImage: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var adClient: ADClient {
    get { self[ADClient.self] }
    set { self[ADClient.self] = newValue }
  }
}
