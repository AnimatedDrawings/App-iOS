//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/09.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: NetworkStorage.projectName,
  options: .enableCodeCoverage,
  targets: NetworkStorage.uFeatureTargets(dependencies: [Shared.projectDepedency])
)
