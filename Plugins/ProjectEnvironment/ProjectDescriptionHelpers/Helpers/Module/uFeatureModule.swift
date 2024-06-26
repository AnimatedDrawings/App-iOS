//
//  uFeatureModule.swift
//  ProjectEnvironment
//
//  Created by chminii on 1/7/24.
//

import ProjectDescription

public protocol uFeatureModule: Module {}

public extension uFeatureModule {
  static func uPresentationTargets(
    dependencies: [TargetDependency]
  ) -> [Target] {
    return [
      example(),
      views(),
      featuresUPresentation(),
      testsUPresentation(),
      testings(),
      interfaces(dependencies: dependencies)
    ]
  }
  
  static func uFeatureTargets(
    dependencies: [TargetDependency]
  ) -> [Target] {
    return [
      tests(),
      testings(),
      features(),
      interfaces(dependencies: dependencies)
    ]
  }
}

public enum uFeatureModuleTarget {
  case example
  case views
  case features
  case featuresUPresentation
  case tests
  case testings
  case interfaces
  
  func source() -> String {
    switch self {
    case .example:
      "Example/**"
    case .views:
      "Views/**"
    case .features, .featuresUPresentation:
      "Features/**"
    case .tests:
      "Tests/**"
    case .testings:
      "Testings/**"
    case .interfaces:
      "Interfaces/**"
    }
  }
  
  func name(_ featureName: String) -> String {
    switch self {
    case .example:
      featureName + "Example"
    case .views:
      featureName
    case .features:
      featureName
    case .featuresUPresentation:
      featureName + "Features"
    case .tests:
      featureName + "Tests"
    case .testings:
      featureName + "Testings"
    case .interfaces:
      featureName + "Interfaces"
    }
  }
}

public extension uFeatureModule {
  static func sourceFilesList(
    _ targets: [uFeatureModuleTarget]
  ) -> SourceFilesList {
    .sourceFilesList(globs: targets.map { $0.source() })
  }
  
  static func targetDependencies(
    _ targets: [uFeatureModuleTarget]
  ) -> [TargetDependency] {
    targets.map { .target(name: $0.name(featureName)) }
  }
  
  static func targetName(
    _ target: uFeatureModuleTarget
  ) -> String {
    target.name(featureName)
  }
}

public extension uFeatureModule {
  static func example(
    sources: [uFeatureModuleTarget] = [.example, .views],
    dependencies: [uFeatureModuleTarget] = [.views, .testings]
  ) -> Target {
    .makeTarget(
      name: targetName(.example),
      product: .app,
      infoPlist: .forPresentationLayer,
      sources: sourceFilesList(sources),
      dependencies: targetDependencies(dependencies)
    )
  }
  
  static func example(
    sources: [uFeatureModuleTarget] = [.example, .views],
    dependencies: [TargetDependency]
  ) -> Target {
    return .makeTarget(
      name: targetName(.example),
      product: .app,
      infoPlist: .forPresentationLayer,
      sources: sourceFilesList(sources),
      dependencies: dependencies
    )
  }
  
  static func views(
    sources: [uFeatureModuleTarget] = [.views],
    dependencies: [uFeatureModuleTarget] = [.featuresUPresentation]
  ) -> Target {
    .makeTarget(
      name: targetName(.views),
      product: .staticLibrary,
      sources: sourceFilesList(sources),
      dependencies: targetDependencies(dependencies)
    )
  }
  
  static func views(
    sources: [uFeatureModuleTarget] = [.views],
    dependencies: [TargetDependency]
  ) -> Target {
    .makeTarget(
      name: targetName(.views),
      product: .staticLibrary,
      sources: sourceFilesList(sources),
      dependencies: dependencies
    )
  }
  
  static func featuresUPresentation(
    sources: [uFeatureModuleTarget] = [.featuresUPresentation],
    dependencies: [uFeatureModuleTarget] = [.interfaces]
  ) -> Target {
    .makeTarget(
      name: targetName(.featuresUPresentation),
      product: .staticLibrary,
      sources: sourceFilesList(sources),
      dependencies: targetDependencies(dependencies)
    )
  }
  
  static func featuresUPresentation(
    sources: [uFeatureModuleTarget] = [.featuresUPresentation],
    dependencies: [TargetDependency]
  ) -> Target {
    .makeTarget(
      name: targetName(.featuresUPresentation),
      product: .staticLibrary,
      sources: sourceFilesList(sources),
      dependencies: dependencies
    )
  }
  
  static func features(
    sources: [uFeatureModuleTarget] = [.features],
    dependencies: [uFeatureModuleTarget] = [.interfaces]
  ) -> Target {
    .makeTarget(
      name: targetName(.features),
      product: .staticLibrary,
      sources: sourceFilesList(sources),
      dependencies: targetDependencies(dependencies)
    )
  }
  
  static func features(
    sources: [uFeatureModuleTarget] = [.features],
    dependencies: [TargetDependency]
  ) -> Target {
    .makeTarget(
      name: targetName(.features),
      product: .staticLibrary,
      sources: sourceFilesList(sources),
      dependencies: dependencies
    )
  }
  
  static func testsUPresentation(
    sources: [uFeatureModuleTarget] = [.tests],
    dependencies: [uFeatureModuleTarget] = [.featuresUPresentation, .testings]
  ) -> Target {
    return .makeTarget(
      name: targetName(.tests),
      product: .unitTests,
      sources: sourceFilesList(sources),
      dependencies: targetDependencies(dependencies)
    )
  }
  
  static func testsUPresentation(
    sources: [uFeatureModuleTarget] = [.tests],
    dependencies: [TargetDependency]
  ) -> Target {
    return .makeTarget(
      name: targetName(.tests),
      product: .unitTests,
      sources: sourceFilesList(sources),
      dependencies: dependencies
    )
  }
  
  static func tests(
    sources: [uFeatureModuleTarget] = [.tests],
    dependencies: [uFeatureModuleTarget] = [.features, .testings]
  ) -> Target {
    return .makeTarget(
      name: targetName(.tests),
      product: .unitTests,
      sources: sourceFilesList(sources),
      dependencies: targetDependencies(dependencies)
    )
  }
  
  static func tests(
    sources: [uFeatureModuleTarget] = [.tests],
    dependencies: [TargetDependency]
  ) -> Target {
    return .makeTarget(
      name: targetName(.tests),
      product: .unitTests,
      sources: sourceFilesList(sources),
      dependencies: dependencies
    )
  }
  
  static func testings(
    sources: [uFeatureModuleTarget] = [.testings],
    dependencies: [uFeatureModuleTarget] = [.interfaces]
  ) -> Target {
    .makeTarget(
      name: targetName(.testings),
      product: .staticLibrary,
      sources: sourceFilesList(sources),
      dependencies: targetDependencies(dependencies)
    )
  }
  
  static func testings(
    sources: [uFeatureModuleTarget] = [.testings],
    dependencies: [TargetDependency]
  ) -> Target {
    .makeTarget(
      name: targetName(.testings),
      product: .staticLibrary,
      sources: sourceFilesList(sources),
      dependencies: dependencies
    )
  }
  
  static func interfaces(
    sources: [uFeatureModuleTarget] = [.interfaces],
    dependencies: [TargetDependency]
  ) -> Target {
    .makeTarget(
      name: targetName(.interfaces),
      product: .staticLibrary,
      sources: sourceFilesList(sources),
      dependencies: dependencies
    )
  }
}
