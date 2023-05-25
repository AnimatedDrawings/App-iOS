import ProjectDescription

public enum MyModule: String {
  case AD_iOS
  case AD_OnBoarding
  case AD_Utils
}

public enum MyLayer: String {
  case App
  case Feature
  case UI
  case Core
  case Share
}

extension Path {
  static func relativeToProjects(layer: MyLayer, project: [MyModule]) -> Path {
    var pathString = "Projects/" + layer.rawValue + "/"
    project.forEach { pathString += $0.rawValue + "/" }
    return .relativeToRoot(pathString)
  }
}

extension TargetDependency {
  public static var AD_OnBoarding: Self {
    return .project(
      target: MyModule.AD_OnBoarding.rawValue,
      path: .relativeToProjects(layer: .Feature, project: [.AD_OnBoarding])
    )
  }
  
  public static var AD_Utils: Self {
    return .project(
      target: MyModule.AD_Utils.rawValue,
      path: .relativeToProjects(layer: .Share, project: [.AD_Utils])
    )
  }
}
