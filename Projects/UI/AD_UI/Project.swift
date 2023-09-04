import ProjectDescription
import ProjectEnvironment

let project = Project.makeModule(
  myModule: .AD_UI,
  platform: .iOS,
  product: .framework,
  dependencies: [
    .AD_CropImage,
    .AD_MaskingImage,
    .AD_ModifyJoints,
    .AD_Feature,
    .AD_Utils,
    .ComposableArchitecture
  ],
  withTest: false
)
