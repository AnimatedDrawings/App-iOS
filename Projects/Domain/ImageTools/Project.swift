//
//  Project.swift
//  Config
//
//  Created by chminii on 2/26/24.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ImageTools.projectName,
  options: .enableCodeCoverage,
  targets: ImageTools.uFeatureTargets(
    dependencies: [DomainModel.projectDepedency]
  )
)
