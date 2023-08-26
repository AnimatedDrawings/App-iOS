//
//  ADFileManager.swift
//  AD_Feature
//
//  Created by minii on 2023/08/25.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

class ADFileManager {
  let fm = FileManager.default
  static let shared = ADFileManager()
  
  func save(with data: Data, fileExtension: String = "gif") throws -> URL {
    let tmpFileURL = fm.temporaryDirectory
      .appendingPathComponent(UUID().uuidString)
      .appendingPathExtension(fileExtension)
    
    guard fm.createFile(atPath: tmpFileURL.path(), contents: data) else {
      throw ADFileManagerError.createFile
    }
    
    return tmpFileURL
  }
  
  func read(with url: URL) throws -> Data {
    guard let dataFromPath: Data = try? Data(contentsOf: url) else {
      throw ADFileManagerError.dataFromPath
    }
    return dataFromPath
  }
}
