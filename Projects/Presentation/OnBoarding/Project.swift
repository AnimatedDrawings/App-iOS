//
//  OnBoarding.swift
//  Config
//
//  Created by minii on 2023/09/12.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = OnBoarding.makeProject(
  targets: [
    OnBoarding.example(dependencies: [.views]),
    OnBoarding.views(dependencies: [Domain.projectDepedency])
  ]
)
