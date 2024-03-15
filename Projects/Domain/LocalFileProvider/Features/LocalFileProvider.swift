//
//  LocalFileProvider.swift
//  LocalFileProvider
//
//  Created by minii on 2023/09/14.
//

import ADComposableArchitecture
import LocalFileProviderInterfaces

public struct LocalFileProvider: DependencyKey {
  public static let liveValue: any LocalFileProviderProtocol = LocalFileProviderImpl()
  public static let testValue: any LocalFileProviderProtocol = TestLocalFileProviderImpl()
}
