import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: Root.projectName,
  options: .enableCodeCoverage,
  targets: Root.uPresentationTargets(
    dependencies: [
      OnBoarding.projectDepedency,
      MakeAD.projectDepedency,
      ConfigureAnimation.projectDepedency
    ]
  )
)
