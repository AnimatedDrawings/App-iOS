//
//  Module.swift
//  ProjectEnvironment
//
//  Created by minii on 2023/09/09.
//

import ProjectDescription

public protocol Module {
  static var projectName: String { get }
  static var targetName: String { get }
  static var prefixPathString: String { get }
}

public extension Module {
  static var path: Path {
    return .relativeToRoot(Self.prefixPathString + "/\(Self.projectName)")
  }
  
  static var projectDepedency: TargetDependency {
    return .project(target: Self.targetName, path: path)
  }
}

// example, test, view, feature
public protocol PresentationModule: Module {}

public extension PresentationModule {
  static func example() -> Target {
    .makeTarget(
      targetName: Self.targetName + "Example",
      product: .app,
      infoPlist: .AD,
      sources: ["Example/**", "Views/**"],
      resources: nil,
      dependencies: [
        .target(name: Self.targetName)
      ]
    )
  }
  
  static func views(dependencies: [TargetDependency]) -> Target {
    .makeTarget(
      targetName: Self.targetName,
      product: .staticLibrary,
      sources: ["Views/**"],
      resources: nil,
      dependencies: dependencies
    )
  }
  
  static func views() -> Target {
    .makeTarget(
      targetName: Self.targetName,
      product: .staticLibrary,
      sources: ["Views/**"],
      resources: nil,
      dependencies: [
        .target(name: Self.targetName + "Features")
      ]
    )
  }
  
  static func features(dependencies: [TargetDependency]) -> Target {
    .makeTarget(
      targetName: Self.targetName + "Features",
      product: .staticLibrary,
      sources: ["Features/**"],
      resources: nil,
      dependencies: dependencies
    )
  }
  
  static func tests() -> Target {
    return Target(
      name: Self.targetName + "Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "chminipark.\(Self.targetName)".replaceBar,
      deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone]),
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [ .target(name: Self.targetName) ]
    )
  }
}
