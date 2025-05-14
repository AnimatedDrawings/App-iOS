//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = NetworkStorage.makeProject(
  options: .enableCodeCoverage,
  targets: NetworkStorage.uFeatureTargets(
    dependencies: [CoreModels.projectDepedency]
  )
)
