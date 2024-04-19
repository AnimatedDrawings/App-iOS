//
//  LocalFileProvider.swift
//  LocalFileProvider
//
//  Created by minii on 2023/09/14.
//

import ADComposableArchitecture
import LocalFileProviderInterfaces
import Foundation

public struct LocalFileProvider: DependencyKey {
  public static var liveValue: any LocalFileProviderProtocol = LocalFileProviderImpl()
  public static var testValue: any LocalFileProviderProtocol = TestLocalFileProviderImpl(isSuccessSaveGIF: true)
}

public extension DependencyValues {
  var localFileProvider: LocalFileProviderProtocol {
    get { self[LocalFileProvider.self] }
    set { self[LocalFileProvider.self] = newValue }
  }
}
