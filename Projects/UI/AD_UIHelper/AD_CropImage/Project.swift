//
//  Project.swift
//  Config
//
//  Created by minii on 2023/08/23.
//

import ProjectDescription
import ProjectEnvironment

let myModule: MyModule = .AD_CropImage

let project: Project = .makeProject(
  myModule: myModule,
  targets: [
    .makeTarget(
      targetName: myModule.name,
      product: .staticLibrary,
      dependencies: [
        .release(.AD_Utils)
      ]
    )
  ],
  schemes: []
)
