//
//  Project.swift
//  Config
//
//  Created by chminii on 2/26/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = ImageTools.makeProject(
  options: .enableCodeCoverage,
  targets: ImageTools.uFeatureTargets(
    dependencies: [Shared.projectDepedency]
  )
)
