//
//  TestLocalFileProviderImpl.swift
//  LocalFileProvider
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import LocalFileProviderInterfaces
import DomainModels
import Foundation

public class TestLocalFileProviderImpl: LocalFileProviderProtocol {
  public func save(file: Data, fileExtension: FileExtension) throws -> SaveLocalFileResponse {
    return .init(fileURL: URL(string: "https://www.apple.com/")!)
  }
  
  public func read(from url: URL) throws -> ReadLocalFileResponse {
    return .init(data: Data())
  }
}
