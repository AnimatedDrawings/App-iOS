//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by minii on 2023/05/23.
//

import ProjectDescription
import ProjectDescriptionHelpers

//let project = Project.makeModule(
//  name: "Sample",
//  platform: .iOS,
//  product: .app,
//  dependencies: [
//    .project(target: "Feature", path: .relativeToRoot("Projects/Feature"))
//  ],
//  resources: ["Resources/**"],
//  infoPlist: .file(path: "Support/Info.plist")
//)


let project = Project.makeModule(
  name: "iOS",
  platform: .iOS,
  product: .app,
  deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone, .ipad]),
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(with: [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true),
  ])
)
