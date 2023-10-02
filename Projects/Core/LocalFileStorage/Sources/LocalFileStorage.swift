//
//  LocalFileStorage.swift
//  LocalFileManager
//
//  Created by minii on 2023/09/14.
//

import Foundation

public class LocalFileStorage {
  let fm = FileManager.default
  public static let shared = LocalFileStorage()
  
  public func save(with data: Data, fileExtension: String = "gif") throws -> URL {
    let tmpFileURL = fm.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(fileExtension)
    
    guard fm.createFile(atPath: tmpFileURL.path(), contents: data) else {
      throw LocalFileStorageError.createFile
    }
    
    return tmpFileURL
  }
  
  public func read(with url: URL) throws -> Data {
    guard let dataFromPath: Data = try? Data(contentsOf: url) else {
      throw LocalFileStorageError.dataFromPath
    }
    return dataFromPath
  }
}
