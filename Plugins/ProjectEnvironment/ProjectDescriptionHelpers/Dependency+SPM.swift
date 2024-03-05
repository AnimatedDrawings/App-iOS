import ProjectDescription

public extension Package {
  static let ComposableArchitecture: Self = .remote(
    url: "https://github.com/pointfreeco/swift-composable-architecture.git",
    requirement: .exact("1.9.2")
  )
}

public extension TargetDependency {
  static let ComposableArchitecture: Self = .package(product: "ComposableArchitecture", type: .macro)
}
