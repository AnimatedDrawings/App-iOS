import ProjectDescription

extension SwiftPackageManagerDependencies {
  public static var packages: Self {
    [
      .ComposableArchitecture
    ]
  }
}

extension Package {
  static let ComposableArchitecture = Package.remote(
    url: "https://github.com/pointfreeco/swift-composable-architecture.git",
    requirement: .exact("0.53.2")
  )
}

extension TargetDependency {
  public static let ComposableArchitecture = TargetDependency.external(name: "ComposableArchitecture")
}
