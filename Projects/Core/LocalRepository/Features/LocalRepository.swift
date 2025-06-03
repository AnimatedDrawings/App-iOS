//
//  LocalRepository.swift
//  LocalRepository
//
//  Created by minii on 2023/09/14.
//

import ADComposableArchitecture
import LocalRepositoryInterfaces
import Foundation

public struct LocalRepository: DependencyKey {
  public static var liveValue: any LocalRepositoryProtocol = LocalRepositoryImpl()
  public static var testValue: any LocalRepositoryProtocol = TestLocalRepositoryImpl(isSuccessSaveGIF: true)
}

public extension DependencyValues {
  var localFileProvider: LocalRepositoryProtocol {
    get { self[LocalRepository.self] }
    set { self[LocalRepository.self] = newValue }
  }
}
