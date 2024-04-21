//
//  MakeADProviderImpl.swift
//  NetworkProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import DomainModels
import NetworkStorage
import NetworkProviderInterfaces
import CoreModels
import ADErrors
import UIKit

final public class MakeADProviderImpl: MakeADProviderProtocol {
  let storage: MakeADStorageProtocol
  
  public init(storage: MakeADStorageProtocol = MakeADStorage()) {
    self.storage = storage
  }
  
  public func uploadDrawing(image: Data) async throws -> UploadDrawingResponse {
    let request = UploadDrawingRequest(convertedPNG: image)
    let response = try await storage.uploadDrawing(request: request)
    let ad_id = response.ad_id
    let boundingBox = BoundingBox(dto: response.boundingBoxDTO)

    return UploadDrawingResponse(ad_id: ad_id, boundingBox: boundingBox)
  }
  
  public func findTheCharacter(ad_id: String, boundingBox: BoundingBox) async throws {
    let request = FindTheCharacterRequest(ad_id: ad_id, boundingBoxDTO: boundingBox.toDTO())
    let _ = try await storage.findTheCharacter(request: request)
  }
  
  public func downloadMaskImage(ad_id: String) async throws -> DownloadMaskImageResponse {
    let request = DownloadMaskImageRequest(ad_id: ad_id)
    let response = try await storage.downloadMaskImage(request: request)
    guard let image = UIImage(data: response.image) else {
      throw MakeADProviderError.maskDataToImage
    }
    
    return DownloadMaskImageResponse(image: image)
  }
  
  public func separateCharacter(ad_id: String, maskedImage: Data) async throws -> SeparateCharacterResponse {
    let request = SeparateCharacterRequest(ad_id: ad_id, maskedImageData: maskedImage)
    let response = try await storage.separateCharacter(request: request)
    let joints = Joints(dto: response.jointsDTO)
    
    return SeparateCharacterResponse(joints: joints)
  }
  
  public func findCharacterJoints(ad_id: String, joints: Joints) async throws {
    let request = FindCharacterJointsRequest(ad_id: ad_id, jointsDTO: joints.toDTO())
    let _ = try await storage.findCharacterJoints(request: request)
  }
  
}

extension BoundingBox {
  func toDTO() -> BoundingBoxDTO {
    let top = Int(cgRect.origin.y)
    let bottom = top + Int(cgRect.height)
    let left = Int(cgRect.origin.x)
    let right = left + Int(cgRect.width)
    
    return BoundingBoxDTO(top: top, bottom: bottom, left: left, right: right)
  }
}

extension Joints {
  func toDTO() -> JointsDTO {
    let width = Int(self.imageWidth)
    let height = Int(self.imageHeight)
    let skeletonDTO = self.skeletons.map { _, skeleton in
      let locationX = Int(skeleton.ratioPoint.x * self.imageWidth)
      let locationY = Int(skeleton.ratioPoint.y * self.imageHeight)
      
      return SkeletonDTO(
        name: skeleton.name,
        location: [locationX, locationY],
        parent: skeleton.parent
      )
    }
    
    return JointsDTO(width: width, height: height, skeletonDTO: skeletonDTO)
  }
}
