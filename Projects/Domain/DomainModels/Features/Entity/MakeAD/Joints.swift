//
//  Joints.swift
//  ModifyJoints
//
//  Created by minii on 2023/07/18.
//

import NetworkRepositoryInterfaces
import Foundation

public struct Joints: Equatable, Decodable {
  public let imageWidth: CGFloat
  public let imageHeight: CGFloat
  public var skeletons: [String: Skeleton]

  public init(
    imageWidth: CGFloat,
    imageHeight: CGFloat,
    skeletons: [String: Skeleton]
  ) {
    self.imageWidth = imageWidth
    self.imageHeight = imageHeight
    self.skeletons = skeletons
  }

  public init(dto: JointsDTO) {
    let imageWidth = CGFloat(dto.width)
    let imageHeight = CGFloat(dto.height)
    let skeletons = dto.skeletonDTO
      .reduce(
        into: [String: Skeleton](),
        { dict, dto in
          let name: String = dto.name
          let ratioX: CGFloat = imageWidth == 0 ? 0 : CGFloat(dto.location[0]) / imageWidth
          let ratioY: CGFloat = imageHeight == 0 ? 0 : CGFloat(dto.location[1]) / imageHeight
          let ratioPoint = RatioPoint(x: ratioX, y: ratioY)

          dict[name] = Skeleton(
            name: name,
            ratioPoint: ratioPoint,
            parent: dto.parent
          )
        })

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

extension Joints {
  public static func mock() -> Self {
    return Self(dto: JointsDTO.mock())
  }

  public static func example1() -> Self {
    return Self(dto: JointsDTO.example1())
  }
}
