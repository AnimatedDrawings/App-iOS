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
  func save(file: Data, fileExtension: FileExtension) throws -> SaveLocalFileResponse
  func read(from url: URL) throws -> ReadLocalFileResponse
}
