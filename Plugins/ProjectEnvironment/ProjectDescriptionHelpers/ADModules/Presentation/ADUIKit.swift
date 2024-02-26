//
//  ADUIKit.swift
//  ProjectEnvironment
//
//  Created by minii on 2023/09/18.
//

import Foundation

//public struct ADUIKit: Module {
//  public static var prefixPathString: String = Presentation.prefixPathString
//  let sources = projectName + "Sources"
//  let resources = projectName + "Resources"
//}
import ProjectDescription

public struct ADUIKit: uFeatureModule {
  public static var prefixPathString: String = Presentation.prefixPathString
  public static let sources: String = projectName + "Sources"
  public static let resources: String = projectName + "Resources"
  public static var projectDepedency: TargetDependency {
    .project(target: Self.sources, path: path)
  }
}
