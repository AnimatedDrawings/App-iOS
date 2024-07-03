//
//  Project.swift
//  Config
//
//  Created by minii on 2023/10/09.
//

import ProjectDescription
import ProjectEnvironment

let networkStorageFeatures: ProjectDescription.Target = .makeTarget(
  name: NetworkStorage.targetName(.features),
  product: .staticLibrary,
  sources: NetworkStorage.sourceFilesList([.features]),
  resources: ["ENV/**"],
  dependencies: NetworkStorage.targetDependencies([.interfaces])
)

let project: Project = NetworkStorage.makeProject(
  targets: [
    NetworkStorage.tests(),
    NetworkStorage.testings(),
    networkStorageFeatures,
    NetworkStorage.interfaces(
      dependencies: [CoreModels.projectDepedency]
    )
  ]
)
