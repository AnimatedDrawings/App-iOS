//
//  InfoPlist.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.
//

import ProjectDescription

public extension ProjectDescription.InfoPlist {
  static var AD: Self {
    return .extendingDefault(with: defaultPlistValue)
  }
  
  static func extendingAD(with pListValue: [String : Plist.Value]) -> ProjectDescription.InfoPlist {
    let newPlistValue: [String : Plist.Value] = defaultPlistValue.merging(pListValue) { (_, new) in
      new
    }
    return .extendingDefault(with: newPlistValue)
  }
  
  static let defaultPlistValue: [String : Plist.Value] =  [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true),
    "NSPhotoLibraryUsageDescription": "We need access to photo library so that photos can be selected",
    "NSPhotoLibraryAddUsageDescription": "This app requires access to the photo library.",
    "UIUserInterfaceStyle": "Light",
    "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"],
    "BASE_URL": "$(BASE_URL)"
  ]
}
