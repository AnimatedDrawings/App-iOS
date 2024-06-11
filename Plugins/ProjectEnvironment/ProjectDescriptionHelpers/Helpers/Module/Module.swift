//
//  File.swift
//  ProjectEnvironment
//
//  Created by chminii on 6/9/24.
//

import ProjectDescription

public protocol Module {
  static var prefixPathString: String { get }
  static var projectName: String { get }
  static var featureName: String { get }
  static var projectDepedency: TargetDependency { get }
  static func makeProject(
    name: String,
    path: Path,
    options: ProjectDescription.Project.Options,
    packages: [ProjectDescription.Package],
    settings: ProjectDescription.Settings?,
    targets: [ProjectDescription.Target],
    fileHeaderTemplate: ProjectDescription.FileHeaderTemplate?,
    additionalFiles: [FileElement],
    resourceSynthesizers: [ProjectDescription.ResourceSynthesizer]
  ) -> Project
}

public extension Module {
  static var projectName: String {
    String(describing: Self.self)
  }
  
  static var featureName: String {
    projectName
  }
  
  static var path: Path {
    .relativeToRoot(Self.prefixPathString + "/\(Self.projectName)")
  }
  
  static var projectDepedency: TargetDependency {
    .project(target: Self.featureName, path: path)
  }
  
  static func makeProject(
    name: String = projectName,
    path: Path = path,
    options: ProjectDescription.Project.Options = .options(),
    packages: [ProjectDescription.Package] = [],
    settings: ProjectDescription.Settings? = .settings(configurations: [.dev, .prd]),
    targets: [ProjectDescription.Target] = [],
    fileHeaderTemplate: ProjectDescription.FileHeaderTemplate? = nil,
    additionalFiles: [FileElement] = [],
    resourceSynthesizers: [ProjectDescription.ResourceSynthesizer] = .default
  ) -> Project {
    let schemes: [ProjectDescription.Scheme] = [
      .makeScheme(
        name: name,
        targets: targets.map { .project(path: path, target: $0.name) },
        type: .dev
      ),
      .makeScheme(
        name: name,
        targets: targets.map { .project(path: path, target: $0.name) },
        type: .prd
      )
    ]
    
    return Project(
      name: name,
      organizationName: .chminipark,
      options: options,
      packages: packages,
      settings: settings,
      targets: targets,
      schemes: schemes,
      fileHeaderTemplate: fileHeaderTemplate,
      additionalFiles: additionalFiles,
      resourceSynthesizers: resourceSynthesizers
    )
  }
}
