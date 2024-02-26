import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: RootView.projectName,
  targets: [
    RootView.example(dependencies: [.views]),
    RootView.views(
      dependencies: [
        OnBoarding.projectDepedency,
        MakeAD.projectDepedency,
        ConfigureAnimation.projectDepedency
      ]
    )
  ]
)
