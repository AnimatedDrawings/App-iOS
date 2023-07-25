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
  var step1UploadDrawing: @Sendable (Data) async throws -> String
}

extension MakeADClient: DependencyKey {
  static let liveValue = Self(
    step1UploadDrawing: { imageData in
      let name = "file"
      let fileName = "tmp"
      let mimeType = imageData.mimeType
      
      let response = await providerMakeAD.request(
        .step1UploadDrawing(
          imageData: imageData,
          name: name,
          fileName: fileName,
          mimeType: mimeType
        )
      )
      
      switch response {
      case .success(let success):
        guard let responseString = String(data: success.data, encoding: .utf8) else {
          throw MoyaError.stringMapping(success)
        }
        return responseString
      case .failure(let failure):
        print(failure.localizedDescription)
        throw failure
      }
    }
  )
  
  static let testValue = Self(
    step1UploadDrawing: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var makeADClient: MakeADClient {
    get { self[MakeADClient.self] }
    set { self[MakeADClient.self] = newValue }
  }
}
