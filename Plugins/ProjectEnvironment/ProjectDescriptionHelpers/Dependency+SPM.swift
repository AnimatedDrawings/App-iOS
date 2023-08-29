import ProjectDescription

extension SwiftPackageManagerDependencies {
  public static var packages: Self {
    [
      .ComposableArchitecture,
      .Moya
    ]
  }
}

extension Package {
  static let ComposableArchitecture = Package.remote(
    url: "https://github.com/pointfreeco/swift-composable-architecture.git",
    requirement: .exact("1.2.0")
  )
  
  static let Moya = Package.remote(
    url: "https://github.com/Moya/Moya.git",
    requirement: .upToNextMajor(from: "15.0.0")
  )
}

extension TargetDependency {
  public static let ComposableArchitecture = TargetDependency.external(name: "ComposableArchitecture")
  public static let Moya = TargetDependency.external(name: "Moya")
}
