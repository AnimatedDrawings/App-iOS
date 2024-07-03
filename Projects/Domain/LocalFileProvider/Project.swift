//
//  Project.swift
//  Config
//
//  Created by minii on 2023/09/14.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = LocalFileProvider.makeProject(
  options: .enableCodeCoverage,
  targets: LocalFileProvider.uFeatureTargets(
    dependencies: [DomainModels.projectDepedency]
  )
)
