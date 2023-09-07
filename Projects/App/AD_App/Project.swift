import ProjectDescription
import ProjectEnvironment

let infoPlist: InfoPlist = .extendingDefault(with: [
  "UIMainStoryboardFile": "",
  "UILaunchStoryboardName": "LaunchScreen",
  "ENABLE_TESTS": .boolean(true),
  "NSPhotoLibraryUsageDescription": "We need access to photo library so that photos can be selected",
  "NSPhotoLibraryAddUsageDescription": "This app requires access to the photo library.",
  "UIUserInterfaceStyle": "Light",
  "UISupportedInterfaceOrientations": ["UIInterfaceOrientationPortrait"]
])

let myModule: MyModule = .AD_App

let project = Project.makeProject(
  myModule: myModule,
  targets: [
    .makeTarget(
      targetName: myModule.name,
      product: .app,
      infoPlist: infoPlist,
      dependencies: [.release(.AD_UI)]
    )
  ],
  schemes: []
)
