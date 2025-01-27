import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = App.makeProject(
  targets: [
    .makeTarget(
      name: App.featureName,
      product: .app,
      infoPlist: .forPresentationLayer,
      resources: .resource,
      dependencies: [
        Presentation.projectDepedency
      ]
    )
  ]
)
