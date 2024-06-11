import ProjectDescription
import ProjectEnvironment

let project: Project = App.makeProject(
  targets: [
    .makeTarget(
      name: App.featureName,
      product: .app,
      infoPlist: .AD,
      resources: .resource,
      dependencies: [
        Presentation.projectDepedency
      ]
    )
  ]
)
