//
//  LocalFileProviderImpl.swift
//  LocalFileProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADErrors
import LocalFileProviderInterfaces
import Foundation
import Photos

public class LocalFileProviderImpl: LocalFileProviderProtocol {
  let fileManager: FileManagerProtocol
  let phPhotoLibrary: PHPhotoLibraryProtocol
  
  public init(
    fileManager: FileManagerProtocol = FileManager.default,
    phPhotoLibrary: PHPhotoLibraryProtocol = PHPhotoLibrary.shared()
  ) {
    self.fileManager = fileManager
    self.phPhotoLibrary = phPhotoLibrary
  }
  
  public func saveGIF(fileUrl: URL) async throws {
    try await withCheckedThrowingContinuation { continuation in
      phPhotoLibrary.performChanges {
        let request = PHAssetCreationRequest.forAsset()
        request.addResource(with: .photo, fileURL: fileUrl, options: nil)
      } completionHandler: { isSuccess, error in
        if isSuccess {
          continuation.resume()
        } else {
          continuation.resume(throwing: LocalFileProviderError.saveGifInPhotos)
        }
      }
    }
  }
  
  public func save(data: Data, fileExtension: FileExtension) throws -> SaveLocalFileResponse {
    let fileURL = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(fileExtension.rawValue)
    
    guard fileManager.createFile(atPath: fileURL.path(), contents: data, attributes: nil) else {
      throw LocalFileProviderError.createFile
    }
    
    return .init(fileURL: fileURL)
  }
  
  public func read(from url: URL) throws -> ReadLocalFileResponse {
    guard let data = try? Data(contentsOf: url) else {
      throw LocalFileProviderError.fetchData
    }
    return .init(data: data)
  }
}
