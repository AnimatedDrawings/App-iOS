//
//  Project.swift
//  Config
//
//  Created by chminii on 3/4/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project: Project = ADAlamofire.makeProject(
  targets: [
    .makeTarget(
      name: ADAlamofire.projectName,
      product: .staticLibrary,
      dependencies: [
        .external(name: "Alamofire")
      ]
    )
  ]
)
