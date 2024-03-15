//
//  LocalFileProviderImpl.swift
//  LocalFileProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import ADErrors
import LocalFileProviderInterfaces
import DomainModels
import Foundation

public class LocalFileProviderImpl: LocalFileProviderProtocol {
  let fileManager: FileManagable
  
  public init(fileManager: FileManagable = FileManager.default) {
    self.fileManager = fileManager
  }
  
  public func save(file: Data, fileExtension: FileExtension) throws -> SaveLocalFileResponse {
    let fileURL = FileManager.default.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(fileExtension.rawValue)
    
    guard fileManager.createFile(atPath: fileURL.path(), contents: file, attributes: nil) else {
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
