//
//  MockPHPotoLibraryFailure.swift
//  LocalFileProviderTestings
//
//  Created by chminii on 4/19/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import Foundation
import LocalRepositoryInterfaces

public final class MockPHPotoLibrary: PHPhotoLibraryProtocol {
  let isSuccess: Bool
  
  public init(isSuccess: Bool) {
    self.isSuccess = isSuccess
  }
  
  public func performChanges(
    _ changeBlock: @escaping () -> Void,
    completionHandler: ((Bool, (any Error)?) -> Void)?
  ) {
    if let completionHandler = completionHandler {
      completionHandler(isSuccess, nil)
    }
  }
}
