import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_UIDemo,
  platform: .iOS,
  product: .app,
  dependencies: [
    .AD_UI
  ],
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(with: [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true)
  ]),
  withTest: false
)
