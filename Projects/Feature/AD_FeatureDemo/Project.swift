import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_FeatureDemo,
  platform: .iOS,
  product: .app,
  dependencies: [
    .AD_Feature
  ],
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(with: [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true)
  ]),
  withTest: false
)
