//
//  Project.swift
//  Config
//
//  Created by minii on 2023/08/21.
//

import ProjectDescription
import ProjectEnvironment

let myModule: MyModule = .AD_MaskingImage

let project: Project = .makeProject(
  myModule: myModule,
  targets: [
    .makeTarget(
      targetName: myModule.name,
      product: .staticFramework,
      dependencies: [
        .release(.AD_Utils)
      ]
    )
  ],
  schemes: []
)
