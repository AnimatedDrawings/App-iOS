import ProjectDescription

public enum MyModule: String {
  case AD_iOS
  
  case AD_Feature
  
  case AD_UI
  case AD_UIDemo
  
  case AD_MaskingImage
  case AD_CropImage
  case AD_ModifyJoints
  
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
  public static var AD_Feature: Self {
    return .project(
      target: MyModule.AD_Feature.rawValue,
      path: .relativeToProjects(layer: .Feature, project: [.AD_Feature])
    )
  }
  
  public static var AD_Utils: Self {
    return .project(
      target: MyModule.AD_Utils.rawValue,
      path: .relativeToProjects(layer: .Share, project: [.AD_Utils])
    )
  }
  
  public static var AD_UI: Self {
    return .project(
      target: MyModule.AD_UI.rawValue,
      path: .relativeToProjects(layer: .UI, project: [.AD_UI])
    )
  }
  
  public static var AD_MaskingImage: Self {
    let pathString = "Projects/UI/AD_UIHelper/AD_MaskingImage"
    
    return .project(
      target: MyModule.AD_MaskingImage.rawValue,
      path: .relativeToRoot(pathString)
    )
  }
  
  public static var AD_CropImage: Self {
    let pathString = "Projects/UI/AD_UIHelper/AD_CropImage"
    
    return .project(
      target: MyModule.AD_CropImage.rawValue,
      path: .relativeToRoot(pathString)
    )
  }
  
  public static var AD_ModifyJoints: Self {
    let pathString = "Projects/UI/AD_UIHelper/AD_ModifyJoints"
    
    return .project(
      target: MyModule.AD_ModifyJoints.rawValue,
      path: .relativeToRoot(pathString)
    )
  }
}
