import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_Demo,
  platform: .iOS,
  product: .app,
  dependencies: [
    .AD_OnBoarding
  ],
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(with: [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true)
  ]),
  withTest: false
)
