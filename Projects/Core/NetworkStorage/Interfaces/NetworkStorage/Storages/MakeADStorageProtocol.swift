//
//  MakeADStorageProtocol.swift
//  NetworkStorageInterfaces
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import CoreModels

public protocol MakeADStorageProtocol {
  func uploadDrawing(request: UploadADrawingRequest) async throws -> UploadADrawingResponse
  func findTheCharacter(request: FindTheCharacterRequest) async throws -> EmptyResponse
  func downloadMaskImage(request: DownloadMaskImageRequest) async throws -> Data
  func separateCharacter(request: SeparateCharacterRequest) async throws -> SeparateCharacterReponse
  func findCharacterJoints(request: FindCharacterJointsRequest) async throws -> EmptyResponse
}
