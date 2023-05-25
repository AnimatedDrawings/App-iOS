import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  module: .AD_iOS,
  platform: .iOS,
  product: .app,
  dependencies: [
    .AD_OnBoarding
  ],
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(with: [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true),
  ]),
  withTest: true
)
