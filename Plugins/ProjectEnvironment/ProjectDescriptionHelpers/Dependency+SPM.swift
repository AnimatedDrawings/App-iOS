import ProjectDescription

public extension SwiftPackageManagerDependencies {
  static var packages: Self {
    .init([
      .ComposableArchitecture
    ])
  }
}

extension Package {
  static var ComposableArchitecture: Self {
    .remote(
      url: "https://github.com/pointfreeco/swift-composable-architecture.git",
      requirement: .exact("1.2.0")
    )
  }
}

extension TargetDependency {
  public static let ComposableArchitecture = TargetDependency.external(name: "ComposableArchitecture")
}
