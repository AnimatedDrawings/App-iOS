//
//  ADNetworkProviderImpl.swift
//  NetworkProvider
//
//  Created by chminii on 3/4/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import DomainModels
import NetworkStorage
import NetworkProviderInterfaces
import CoreModels
import ADErrors
import UIKit

final public class ADNetworkProviderImpl: ADNetworkProviderProtocol {
  
  let storage: ADNetworkStorageProtocol
  
  public init(storage: ADNetworkStorageProtocol = ADNetworkStorage()) {
    self.storage = storage
  }
  
  public func uploadDrawing(
    image: Data
  )
  async throws -> UploadDrawingResponse {
    let request = UploadDrawingRequest(convertedPNG: image)
    let result = await storage.uploadDrawing(request: request)
    switch result {
    case .success(let response):
      let ad_id = response.ad_id
      let boundingBox = BoundingBox(dto: response.boundingBoxDTO)
      return UploadDrawingResponse(ad_id: ad_id, boundingBox: boundingBox)
    case .failure(let error):
      throw error
    }
  }
  
  public func findCharacter(
    ad_id: String,
    boundingBox: BoundingBox
  ) async throws -> FindCharacterResponse {
    let request = FindCharacterRequest(
      ad_id: ad_id,
      boundingBoxDTO: boundingBox.toDTO()
    )
    let result = await storage.findCharacter(request: request)
    
    switch result {
    case .success(let response):
      guard let image = UIImage(data: response.image) else {
        throw MakeADProviderError.maskDataToImage
      }
      return FindCharacterResponse(image: image)
      
    case .failure(let error):
      throw error
    }
  }
  
  public func cutoutCharacter(
    ad_id: String,
    maskedImage: Data
  ) async throws -> CutoutCharacterResponse {
    let request = CutoutCharacterRequest(ad_id: ad_id, cutoutImageData: maskedImage)
    let result = await storage.cutoutCharacter(request: request)
    
    switch result {
    case .success(let response):
      let joints = Joints(dto: response.jointsDTO)
      return CutoutCharacterResponse(joints: joints)
    case .failure(let error):
      throw error
    }
  }
  
  public func configureCharacterJoints(
    ad_id: String,
    joints: Joints
  ) async throws {
    let request = ConfigureCharacterJointsRequest(ad_id: ad_id, jointsDTO: joints.toDTO())
    let result = await storage.configureCharacterJoints(request: request)
    
    switch result {
    case .success:
      return
    case .failure(let error):
      throw error
    }
  }
  
  public func makeAnimation(
    ad_id: String,
    animation: ADAnimation
  ) async throws -> MakeAnimationResponse {
    let request = MakeAnimationRequest(
      ad_id: ad_id,
      adAnimation: animation.rawValue
    )
    let result = await storage.makeAnimation(request: request)
    
    switch result {
    case .success(let response):
      return MakeAnimationResponse(animation: response.animation)
    case .failure(let error):
      throw error
    }
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

