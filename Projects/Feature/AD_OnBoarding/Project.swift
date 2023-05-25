import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  name: "AD_OnBoarding",
  platform: .iOS,
  product: .staticFramework,
  dependencies: [
    .ComposableArchitecture
  ]
//  resources: ["Resources/**"],
//  infoPlist: .extendingDefault(with: [
//    "UIMainStoryboardFile": "",
//    "UILaunchStoryboardName": "LaunchScreen",
//    "ENABLE_TESTS": .boolean(true),
//  ])
)
