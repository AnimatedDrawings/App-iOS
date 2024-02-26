import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: Presentation.projectName,
  targets: [
    .makeTarget(
      name: Presentation.projectName, 
      product: .staticLibrary,
      dependencies: [RootView.projectDepedency]
    )
  ]
)
