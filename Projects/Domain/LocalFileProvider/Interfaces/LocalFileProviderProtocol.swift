//
//  LocalFileProviderProtocol.swift
//  LocalFileProviderInterfaces
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import DomainModels

public protocol LocalFileProviderProtocol {
  func saveGIF(fileUrl: URL) async throws
  func save(data: Data, fileExtension: FileExtension) throws -> SaveLocalFileResponse
  func read(from url: URL) throws -> ReadLocalFileResponse
}
