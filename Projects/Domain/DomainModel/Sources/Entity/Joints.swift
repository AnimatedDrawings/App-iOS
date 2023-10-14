//
//  Joints.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/18.
//

import Foundation

public struct Joints: Equatable, Decodable {
  public let imageWidth: CGFloat
  public let imageHeight: CGFloat
  public var skeletons: [String : Skeleton]
  
  public init(
    imageWidth: CGFloat,
    imageHeight: CGFloat,
    skeletons: [String : Skeleton]
  ) {
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
    self.skeletons = skeletons
  }
}

public struct Skeleton: Equatable, Decodable {
  public var name: String
  public var ratioPoint: RatioPoint
  public var parent: String?
  
  public init(name: String, ratioPoint: RatioPoint, parent: String? = nil) {
    self.name = name
    self.ratioPoint = ratioPoint
    self.parent = parent
  }
}

public struct RatioPoint: Equatable, Decodable {
  public var x: CGFloat
  public var y: CGFloat
  
  public init(x: CGFloat, y: CGFloat) {
    self.x = x
    self.y = y
  }
}
