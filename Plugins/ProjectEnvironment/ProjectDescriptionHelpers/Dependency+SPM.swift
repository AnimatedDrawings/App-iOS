import ProjectDescription

public extension Package {
  static let ComposableArchitecture: Self = .remote(
    url: "https://github.com/pointfreeco/swift-composable-architecture.git",
    requirement: .exact("1.9.3")
  )
  
  static let AsyncAlgorithms: Self = .remote(
    url: "https://github.com/apple/swift-async-algorithms",
    requirement: .exact("1.0.0")
  )
}

public extension TargetDependency {
  static let ComposableArchitecture: Self = .package(product: "ComposableArchitecture", type: .macro)
  static let AsyncAlgorithms: Self = .package(product: "AsyncAlgorithms")
}
