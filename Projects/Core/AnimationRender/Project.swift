import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = AnimationRender.makeProject(
  options: .enableCodeCoverage,
  targets: [
    AnimationRender.exampleTarget(),
    AnimationRender.featuresTarget(),
    AnimationRender.tests(),
    AnimationRender.testings(),
    AnimationRender.interfaces(dependencies: [CoreModels.projectDepedency]),
  ]
)
