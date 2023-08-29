import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_iOS,
  platform: .iOS,
  product: .app,
  dependencies: [
    .AD_UI
  ],
  resources: ["Resources/**"],
  infoPlist: .extendingDefault(with: [
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "ENABLE_TESTS": .boolean(true),
    "NSPhotoLibraryUsageDescription": "We need access to photo library so that photos can be selected",
    "NSPhotoLibraryAddUsageDescription": "This app requires access to the photo library.",
    "UIUserInterfaceStyle": "Light"
  ]),
  withTest: false
)
