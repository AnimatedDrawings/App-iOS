//
//  TestLocalFileProviderImpl.swift
//  LocalFileProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import LocalFileProviderInterfaces
import Foundation
import ADErrors

public class TestLocalFileProviderImpl: LocalFileProviderProtocol {
  public var isSuccessSaveGIF: Bool
  
  public init(isSuccessSaveGIF: Bool = true) {
    self.isSuccessSaveGIF = isSuccessSaveGIF
  }
  
  public func saveGIF(fileUrl: URL) async throws {
    if isSuccessSaveGIF {
      return
    } else {
      throw LocalFileProviderError.saveGifInPhotos
    }
  }
  
  public func save(data: Data, fileExtension: FileExtension) throws -> SaveLocalFileResponse {
    return .mock()
  }
  
  public func read(from url: URL) throws -> ReadLocalFileResponse {
    return .mock()
  }
}
