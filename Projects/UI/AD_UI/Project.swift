import ProjectDescription
import ProjectEnvironment

let myModule: MyModule = .AD_UI

let project: Project = .makeProject(
  myModule: myModule,
  targets: [
    .makeTarget(
      targetName: myModule.name,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        .release(.AD_CropImage),
        .release(.AD_MaskingImage),
        .release(.AD_ModifyJoints),
        .release(.AD_Feature),
        .release(.AD_Utils),
        .ComposableArchitecture
      ]
    )
  ],
  schemes: []
)

