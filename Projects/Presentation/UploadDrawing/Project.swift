//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/03.
//

import ProjectDescription
import ProjectEnvironment

let project: Project = UploadDrawing.makeProject(
  options: .enableCodeCoverage,
  targets: UploadDrawing
    .uPresentationTargets(
      dependencies: [Domain.projectDepedency]
    )
)
