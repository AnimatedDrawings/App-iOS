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

struct ADClient {
  var uploadImage: @Sendable (UIImage) async throws -> String
  var imageToAnnotations: @Sendable (UIImage) async throws -> String
}

extension ADClient: DependencyKey {
  static let liveValue = Self(
    uploadImage: { croppedImage in
      guard let data = croppedImage.pngData() else {
        throw UploadImageError.convertData
      }
      let name = "file"
      let fileName = "tmp"
      let mimeType = data.mimeType
      
      let endpoint = providerAD.endpoint(
        .uploadImage(
          data: data,
          name: name,
          fileName: fileName,
          mimeType: mimeType
        )
      )
      guard let urlRequest = try? endpoint.urlRequest() else {
        throw UploadImageError.urlRequest
      }
      guard urlRequest.httpBody != nil else {
        throw UploadImageError.multipartFormData
      }
      
      let response = await providerAD.request(
        .uploadImage(
          data: data,
          name: name,
          fileName: fileName,
          mimeType: mimeType
        )
      )

      switch response {
      case .success(let success):
        let responseString: String = String(data: success.data, encoding: .utf8) ?? "cannot convert success response data"
        return responseString
      case .failure(let failure):
        print(failure.localizedDescription)
        throw failure
      }    
    },
    
    imageToAnnotations: { maskedImage in
//      try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
      return "TEtset"
    }
  )
  
  static let testValue = Self(
    uploadImage: unimplemented("\(Self.self) testValue of search"),
    imageToAnnotations: unimplemented("\(Self.self) testValue of search")
  )
}

extension DependencyValues {
  var adClient: ADClient {
    get { self[ADClient.self] }
    set { self[ADClient.self] = newValue }
  }
}
