//
//  InfoPlist.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.
//

import ProjectDescription

public extension ProjectDescription.InfoPlist {
  static var forPresentationLayer: Self {
    let plist: [String : Plist.Value] = [
      "UIMainStoryboardFile": "",
      "UILaunchStoryboardName": "LaunchScreen",
      "ENABLE_TESTS": .boolean(true),
      "NSPhotoLibraryUsageDescription": "We need access to photo library so that photos can be selected",
      "NSPhotoLibraryAddUsageDescription": "This app requires access to the photo library.",
      "UIUserInterfaceStyle": "Light",
      "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
    ]
    return .extendingDefault(with: plist)
  }
}
