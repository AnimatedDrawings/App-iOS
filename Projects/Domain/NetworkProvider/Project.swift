//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = NetworkProvider.makeProject(
  options: .enableCodeCoverage,
  targets: NetworkProvider.uFeatureTargets(
    dependencies: [DomainModels.projectDepedency]
  )
)
