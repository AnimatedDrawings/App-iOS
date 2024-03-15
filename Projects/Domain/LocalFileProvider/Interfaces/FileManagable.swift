//
//  FileManagable.swift
//  LocalFileProviderInterfaces
//
//  Created by chminii on 3/15/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public protocol FileManagable {
  func createFile(atPath path: String, contents data: Data?, attributes attr: [FileAttributeKey : Any]?) -> Bool
}
