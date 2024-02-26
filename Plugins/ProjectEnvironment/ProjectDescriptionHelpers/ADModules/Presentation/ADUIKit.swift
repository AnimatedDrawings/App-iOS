//
//  ADUIKit.swift
//  ProjectEnvironment
//
//  Created by minii on 2023/09/18.
//

import Foundation
import ProjectDescription

public struct ADUIKit: uFeatureModule {
  public static let prefixPathString: String = Presentation.prefixPathString
  public static let sources: String = projectName + "Sources"
  public static let resources: String = projectName + "Resources"
  public static var projectDepedency: TargetDependency {
    .project(target: Self.sources, path: path)
  }
}
