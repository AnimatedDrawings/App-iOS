//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/09.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: NetworkProvider.projectName,
  options: .enableCodeCoverage,
  targets: NetworkProvider.uFeatureTargets(
    dependencies: [DomainModels.projectDepedency]
  )
)
