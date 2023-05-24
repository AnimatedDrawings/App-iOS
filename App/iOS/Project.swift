import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  name: "iOS",
  platform: .iOS,
  product: .app,
  deploymentTarget: .iOS(targetVersion: "16.0", devices: [.iphone, .ipad]),
  dependencies: [
    .SPM.ComposableArchitecture
  ],
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(with: [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true),
  ])
)
