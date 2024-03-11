//
//  LocalFileProvider.swift
//  LocalFileProvider
//
//  Created by minii on 2023/09/14.
//

import LocalFileStorage
import Foundation
import ADComposableArchitecture

//public let LF = LocalFileStorage.shared

public struct LocalFileProvider {
  public var save: @Sendable (Data, String) throws -> URL
  public var read: @Sendable (URL) throws -> Data
}

extension LocalFileProvider: DependencyKey {
  private static let storage = LocalFileStorage.shared
  
  public static var liveValue = Self(
    save: { data, fileExtension in
      let fileURL = try storage.save(with: data, fileExtension: fileExtension)
      return fileURL
    },
    read: { fileURL in
      let fetchedData = try storage.read(with: fileURL)
      return fetchedData
    }
  )
  
  public static var testValue = Self(
    save: { _, _ in URL(string: "https://www.apple.com")! },
    read: { _ in Data() }
  )
}

public extension DependencyValues {
  var localFileProvider: LocalFileProvider {
    get { self[LocalFileProvider.self] }
    set { self[LocalFileProvider.self] = newValue }
  }
}
