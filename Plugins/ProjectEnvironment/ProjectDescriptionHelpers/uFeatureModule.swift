//
//  uFeatureModule.swift
//  ProjectEnvironment
//
//  Created by chminii on 1/7/24.
//

import ProjectDescription

public protocol uFeatureModule: Module {}

public extension uFeatureModule {
  static func uPresentationTargets(dependency: TargetDependency) -> [Target] {
    return [
      exampleTarget(),
      viewsTarget(),
      featuresTarget(name: featuresUPresentationName),
      testsTarget(dependencyName: featuresUPresentationName),
      testingsTarget(),
      interfacesTarget(dependencies: [dependency])
    ]
  }
  
  static func uPresentationTargets(dependencies: [TargetDependency]) -> [Target] {
    return [
      exampleTarget(),
      viewsTarget(),
      featuresTarget(name: featuresUPresentationName),
      testsTarget(dependencyName: featuresUPresentationName),
      testingsTarget(),
      interfacesTarget(dependencies: dependencies)
    ]
  }
  
  static func uCoreTargets(dependency: TargetDependency) -> [Target] {
    return [
      testsTarget(dependencyName: featuresUCoreName),
      testingsTarget(),
      featuresTarget(name: featuresUCoreName),
      interfacesTarget(dependencies: [dependency])
    ]
  }
  
  static func uCoreTargets(dependencies: [TargetDependency]) -> [Target] {
    return [
      testsTarget(dependencyName: featuresUCoreName),
      testingsTarget(),
      featuresTarget(name: featuresUCoreName),
      interfacesTarget(dependencies: dependencies)
    ]
  }
}

public extension uFeatureModule {
  static var exampleName: String {
    Self.targetName + "Example"
  }
  
  static var viewsName: String {
    Self.targetName
  }
  
  static var featuresUPresentationName: String {
    Self.targetName + "Features"
  }
  
  static var featuresUCoreName: String {
    Self.targetName
  }
  
  static var interfacesName: String {
    Self.targetName + "Interfaces"
  }
  
  static var testsName: String {
    Self.targetName + "Tests"
  }
  
  static var testingsName: String {
    Self.targetName + "Testings"
  }
}

public extension uFeatureModule {
  static func exampleTarget() -> Target {
    .makeTarget(
      targetName: exampleName,
      product: .app,
      infoPlist: .AD,
      sources: ["Example/**", "Views/**"],
      resources: nil,
      dependencies: [
        .target(name: viewsName)
      ]
    )
  }
  
  static func viewsTarget() -> Target {
    .makeTarget(
      targetName: viewsName,
      product: .staticLibrary,
      sources: ["Views/**"],
      resources: nil,
      dependencies: [
        .target(name: featuresUPresentationName)
      ]
    )
  }
  
  static func featuresTarget(name: String) -> Target {
    .makeTarget(
      targetName: name,
      product: .staticLibrary,
      sources: ["Features/**"],
      resources: nil,
      dependencies: [
        .target(name: interfacesName)
      ]
    )
  }
  
  static func testsTarget(dependencyName: String) -> Target {
    .makeTarget(
      targetName: testsName,
      platform: .iOS,
      product: .unitTests,
      sources: ["Tests/**"],
      resources: nil,
      dependencies: [
        .target(name: testingsName),
        .target(name: dependencyName)
      ]
    )
  }
  
  // product?
  static func testingsTarget() -> Target {
    .makeTarget(
      targetName: testingsName,
      platform: .iOS,
      product: .staticLibrary,
      sources: ["Testings/**"],
      resources: nil,
      dependencies: [
        .target(name: interfacesName)
      ]
    )
  }
  
  static func interfacesTarget(dependencies: [TargetDependency]) -> Target {
    .makeTarget(
      targetName: interfacesName,
      product: .staticLibrary,
      sources: ["Interfaces/**"],
      resources: nil,
      dependencies: dependencies
    )
  }
}
