//
//  JointsDTO.swift
//  DTO
//
//  Created by minii on 2023/10/02.
//  Copyright © 2023 chminipark. All rights reserved.
//

import Foundation

public struct JointsDTO: Codable, Equatable {
  public var width: Int
  public var height: Int
  public var skeletonDTO: [SkeletonDTO]

  public init(width: Int, height: Int, skeletonDTO: [SkeletonDTO]) {
    self.width = width
    self.height = height
    self.skeletonDTO = skeletonDTO
  }

  enum CodingKeys: String, CodingKey {
    case width
    case height
    case skeletonDTO = "skeleton"
  }
}

public struct SkeletonDTO: Codable, Equatable {
  public var name: String
  public var location: [Int]
  public var parent: String?

  public init(name: String, location: [Int], parent: String? = nil) {
    self.name = name
    self.location = location
    self.parent = parent
  }

  enum CodingKeys: String, CodingKey {
    case name
    case location = "loc"
    case parent
  }
}

extension JointsDTO {
  public static func mock() -> JointsDTO {
    let data = mockData()
    let dto = try! JSONDecoder().decode(Self.self, from: data)
    return dto
  }

  private static func mockData() -> Data {
    return """
    {
      "height": 882,
      "skeleton": [
        {
          "loc": [
            399,
            641
          ],
          "name": "root",
          "parent": null
        },
        {
          "loc": [
            399,
            641
          ],
          "name": "hip",
          "parent": "root"
        },
        {
          "loc": [
            404,
            265
          ],
          "name": "torso",
          "parent": "hip"
        },
        {
          "loc": [
            399,
            370
          ],
          "name": "neck",
          "parent": "torso"
        },
        {
          "loc": [
            208,
            284
          ],
          "name": "right_shoulder",
          "parent": "torso"
        },
        {
          "loc": [
            142,
            227
          ],
          "name": "right_elbow",
          "parent": "right_shoulder"
        },
        {
          "loc": [
            75,
            170
          ],
          "name": "right_hand",
          "parent": "right_elbow"
        },
        {
          "loc": [
            599,
            246
          ],
          "name": "left_shoulder",
          "parent": "torso"
        },
        {
          "loc": [
            637,
            179
          ],
          "name": "left_elbow",
          "parent": "left_shoulder"
        },
        {
          "loc": [
            665,
            113
          ],
          "name": "left_hand",
          "parent": "left_elbow"
        },
        {
          "loc": [
            275,
            646
          ],
          "name": "right_hip",
          "parent": "root"
        },
        {
          "loc": [
            266,
            741
          ],
          "name": "right_knee",
          "parent": "right_hip"
        },
        {
          "loc": [
            247,
            846
          ],
          "name": "right_foot",
          "parent": "right_knee"
        },
        {
          "loc": [
            523,
            636
          ],
          "name": "left_hip",
          "parent": "root"
        },
        {
          "loc": [
            542,
            731
          ],
          "name": "left_knee",
          "parent": "left_hip"
        },
        {
          "loc": [
            570,
            817
          ],
          "name": "left_foot",
          "parent": "left_knee"
        }
      ],
      "width": 731
    }
    """.data(using: .utf8)!
  }
}
