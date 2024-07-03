import ProjectDescription
import ProjectEnvironment

let project: Project = Presentation.makeProject(
  targets: [
    .makeTarget(
      name: Presentation.projectName,
      product: .staticLibrary,
      dependencies: [Root.projectDepedency]
    )
  ]
)
