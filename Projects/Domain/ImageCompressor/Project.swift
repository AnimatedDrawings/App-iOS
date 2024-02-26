//
//  Project.swift
//  Config
//
//  Created by chminii on 2/26/24.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = .makeProject(
  name: ImageCompressor.projectName,
  targets: ImageCompressor.uFeatureTargets(
    dependencies: [DomainModel.projectDepedency]
  )
)
