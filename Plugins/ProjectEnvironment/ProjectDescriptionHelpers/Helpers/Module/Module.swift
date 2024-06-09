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
}
