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
    requirement: .exact("1.2.0")
  )
}

extension TargetDependency {
  public static let ComposableArchitecture = TargetDependency.external(name: "ComposableArchitecture")
}
