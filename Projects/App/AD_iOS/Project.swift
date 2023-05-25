import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  name: "AD_iOS",
  platform: .iOS,
  product: .app,
  dependencies: [
    .AD_OnBoarding
//    .ComposableArchitecture
  ],
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(with: [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true),
  ])
)
