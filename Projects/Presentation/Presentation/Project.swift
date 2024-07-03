import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = Presentation.makeProject(
  targets: [
    .makeTarget(
      name: Presentation.projectName,
      product: .staticLibrary,
      dependencies: [Root.projectDepedency]
    )
  ]
)
