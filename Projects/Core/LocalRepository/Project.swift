//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/14.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = LocalRepository.makeProject(
  options: .enableCodeCoverage,
  targets: LocalRepository.uFeatureTargets(
    dependencies: [Shared.projectDepedency]
  )
)
