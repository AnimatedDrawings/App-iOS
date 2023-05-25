import ProjectDescription

enum MyProject: String {
  case AD_iOS
  case AD_OnBoarding
}

enum MyLayer: String {
  case App
  case Feature
  case UI
  case Core
  case Share
}

extension Path {
  static func relativeToProjects(layer: MyLayer, project: [MyProject]) -> Path {
    var pathString = "Projects/" + layer.rawValue + "/"
    project.forEach { pathString += $0.rawValue + "/" }
    return .relativeToRoot(pathString)
  }
}

extension TargetDependency {
  public static let AD_OnBoarding = Self.project(
    target: MyProject.AD_OnBoarding.rawValue,
    path: .relativeToProjects(layer: .Feature, project: [.AD_OnBoarding])
  )
}
