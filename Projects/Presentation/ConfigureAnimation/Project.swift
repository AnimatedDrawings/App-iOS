//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let configureAnimationFeaturesUPresentation: ProjectDescription.Target = .makeTarget(
  name: ConfigureAnimation.targetName(.featuresUPresentation),
  product: .staticLibrary,
  sources: ConfigureAnimation.sourceFilesList([.features]),
  resources: ["ENV/**"],
  dependencies: ConfigureAnimation.targetDependencies([.interfaces])
)

let project: Project = ConfigureAnimation.makeProject(
  options: .enableCodeCoverage,
  targets: [
    ConfigureAnimation.example(),
    ConfigureAnimation.views(),
    configureAnimationFeaturesUPresentation,
    ConfigureAnimation.testsUPresentation(),
    ConfigureAnimation.testings(),
    ConfigureAnimation.interfaces(dependencies: [Domain.projectDepedency]),
  ]
)
