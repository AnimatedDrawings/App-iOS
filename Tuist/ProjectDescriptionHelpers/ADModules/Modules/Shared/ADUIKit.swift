//
//  ADUIKit.swift
//  ProjectEnvironment
//
//  Created by minii on 2023/09/18.
//

import Foundation
import ProjectDescription

public struct ADUIKit: uFeatureModule {
  public static let prefixPathString: String = Shared.prefixPathString
  public static let resources: String = "ADResources"
  public static let errors: String = "ADErrors"
}

extension ADUIKit {
  public static func resourceTarget() -> Target {
    return .makeTarget(
      name: Self.resources,
      product: .staticLibrary,
      sources: .sourceFilesList(globs: ["Resources/**"]),
      resources: .resource,
      dependencies: [
        .external(name: "Yams")
      ]
    )
  }

  public static func errorsTarget() -> Target {
    return .makeTarget(
      name: Self.errors,
      product: .staticLibrary,
      sources: .sourceFilesList(globs: ["Errors/**"]),
      dependencies: []
    )
  }
}
