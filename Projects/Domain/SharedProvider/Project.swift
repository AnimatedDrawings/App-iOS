//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/02.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = SharedProvider.makeProject(
  options: .enableCodeCoverage,
  targets: SharedProvider.uFeatureTargets(
    dependencies: [DomainModels.projectDepedency]
  )
)
