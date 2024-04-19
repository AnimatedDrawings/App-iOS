//
//  PHPhotoLibraryProtocol.swift
//  LocalFileProviderInterfaces
//
//  Created by chminii on 4/19/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation

public protocol PHPhotoLibraryProtocol {
  func performChanges(
      _ changeBlock: @escaping () -> Void,
      completionHandler: ((Bool, (any Error)?) -> Void)?
  )
}
