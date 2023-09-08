import ProjectDescription
import ProjectEnvironment

let myModule: MyModule = .AD_Feature

let project = Project.makeProject(
  myModule: myModule,
  targets: [
    .makeTarget(
      targetName: myModule.name,
      product: .staticLibrary,
      resources: nil,
      dependencies: [
        .release(.AD_Shared),
      ]
    )
  ],
  schemes: []
)
