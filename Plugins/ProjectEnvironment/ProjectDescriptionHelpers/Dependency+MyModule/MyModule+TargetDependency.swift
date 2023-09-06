//
//  MyModule+TargetDependency.swift
//  ProjectEnvironment
//
//  Created by minii on 2023/09/06.
//

import ProjectDescription

public extension TargetDependency {
  static func debug(_ myModule: MyModule) -> TargetDependency {
    return .project(target: myModule.debugName, path: myModule.path)
  }
  
  static func release(_ myModule: MyModule) -> TargetDependency {
    return .project(target: myModule.name, path: myModule.path)
  }
}

extension MyModule {
  var path: Path {
    switch self {
    case .AD_iOS:
      return .relativeToRoot("Projects/App/AD_iOS")
    case .AD_Feature:
      return .relativeToRoot("Projects/Feature/AD_Feature")
    case .AD_UI:
      return .relativeToRoot("Projects/UI/AD_UI")
    case .AD_MaskingImage:
      return .relativeToRoot("Projects/UI/AD_UIHelper/AD_MaskingImage")
    case .AD_CropImage:
      return .relativeToRoot("Projects/UI/AD_UIHelper/AD_CropImage")
    case .AD_ModifyJoints:
      return .relativeToRoot("Projects/UI/AD_UIHelper/AD_ModifyJoints")
    case .AD_Utils:
      return .relativeToRoot("Projects/Share/AD_Utils")
    }
  }
}
