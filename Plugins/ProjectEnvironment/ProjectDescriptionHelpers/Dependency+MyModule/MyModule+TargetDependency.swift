//
//  MyModule+TargetDependency.swift
//  ProjectEnvironment
//
//  Created by minii on 2023/09/06.
//

import ProjectDescription

public extension TargetReference {
  static func debug(_ myModule: MyModule) -> Self {
    return .project(path: myModule.path, target: myModule.debugName)
  }
  
  static func release(_ myModule: MyModule) -> Self {
    return .project(path: myModule.path, target: myModule.name)
  }
}

public extension TargetDependency {
  static func debug(_ myModule: MyModule) -> Self {
    return .project(target: myModule.debugName, path: myModule.path)
  }
  
  static func release(_ myModule: MyModule) -> Self {
    return .project(target: myModule.name, path: myModule.path)
  }
}

public extension Path {
  static func myModule(_ myModule: MyModule) -> Self {
    return myModule.path
  }
}

extension MyModule {
  var path: Path {
    switch self {
    case .AD_App:
      return .relativeToRoot("Projects/App/" + self.name)
    case .AD_Feature:
      return .relativeToRoot("Projects/Feature/" + self.name)
    case .AD_UI:
      return .relativeToRoot("Projects/UI/" + self.name)
    case .AD_MaskingImage:
      return .relativeToRoot("Projects/UI/AD_UIHelper/" + self.name)
    case .AD_CropImage:
      return .relativeToRoot("Projects/UI/AD_UIHelper/" + self.name)
    case .AD_ModifyJoints:
      return .relativeToRoot("Projects/UI/AD_UIHelper/" + self.name)
    case .AD_Shared:
      return .relativeToRoot("Projects/Shared/" + self.name)
    case .ThirdPartyLib:
      return .relativeToRoot("Projects/Shared/AD_Shared/" + self.name)
    case .AD_Utils:
      return .relativeToRoot("Projects/Shared/AD_Shared/" + self.name)
    }
  }
}
