//
//  MakeADProvider.swift
//  NetworkProvider
//
//  Created by minii on 2023/10/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ThirdPartyLib
import NetworkStorage
import UIKit
import DomainModel

public struct MakeADProvider {
  public var uploadDrawing: @Sendable (Data) async throws -> (String, CGRect)
  public var findTheCharacter: @Sendable (String, CGRect) async throws -> ()
  public var downloadMaskImage: @Sendable (String) async throws -> (UIImage)
  public var separateCharacter: @Sendable (String, Data) async throws -> (Joints)
  public var findCharacterJoints: @Sendable (String, Joints) async throws -> ()
}

extension MakeADProvider: DependencyKey {
  private static let storage = MakeADStorage.shared
  
  public static let liveValue = Self(
    uploadDrawing: { image in
      let response = try await storage.uploadDrawing(
        request: UploadADrawingRequest(
          convertedPNG: image
        )
      )
      let ad_id = response.ad_id
      let cgRect = response.boundingBoxDTO.toCGRect()
      
      return (ad_id, cgRect)
    },
    
    findTheCharacter: { ad_id, cgRect in
      let boundingBoxDTO = cgRect.toBoundingBoxDTO()
      let response = try await storage.findTheCharacter(
        request: FindTheCharacterRequest(
          ad_id: ad_id,
          boundingBoxDTO: boundingBoxDTO
        )
      )
    },
    downloadMaskImage: { ad_id in
      let response = try await storage.downloadMaskImage(
        request: DownloadMaskImageRequest(
          ad_id: ad_id
        )
      )
      guard let uiImage = UIImage(data: response) else {
        throw DomainError.maskDataToImage
      }
      return uiImage
    },
    
    separateCharacter: { ad_id, maskedImage in
      let response = try await storage.separateCharacter(
        request: SeparateCharacterRequest(
          ad_id: ad_id,
          maskedImageData: maskedImage
        )
      )
      
      return response.jointsDTO.toDomain()
    },
    
    findCharacterJoints: { ad_id, joints in
      let response = try await storage.findCharacterJoints(
        request: FindCharacterJointsRequest(
          ad_id: ad_id,
          jointsDTO: joints.toDTO()
        )
      )
    }
  )
  
  public static let testValue = Self(
    uploadDrawing: unimplemented("\(Self.self) testValue of search"),
    findTheCharacter: unimplemented("\(Self.self) testValue of search"),
    downloadMaskImage: unimplemented("\(Self.self) testValue of search"),
    separateCharacter: unimplemented("\(Self.self) testValue of search"),
    findCharacterJoints: unimplemented("\(Self.self) testValue of search")
  )
}

public extension DependencyValues {
  var makeADProvider: MakeADProvider {
    get { self[MakeADProvider.self] }
    set { self[MakeADProvider.self] = newValue }
  }
}
