//
//  MyModule+Name.swift
//  ProjectEnvironment
//
//  Created by minii on 2023/09/06.
//

import ProjectDescription

public extension MyModule {
  var name: String {
    return self.rawValue
  }
  
  var debugName: String {
    return "debug" + "_" + self.rawValue
  }
}
