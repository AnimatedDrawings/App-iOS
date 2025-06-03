//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = NetworkRepository.makeProject(
  options: .enableCodeCoverage,
  targets: NetworkRepository.uFeatureTargets(
    dependencies: [Shared.projectDepedency]
  )
)
