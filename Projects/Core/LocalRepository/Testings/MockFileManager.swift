//
//  MockFileManager.swift
//  LocalFileProviderTestings
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import LocalRepositoryInterfaces

public final class MockFileManagerFailure: FileManagerProtocol {
  public init() {}
  
  public func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool {
    return false
  }
}
