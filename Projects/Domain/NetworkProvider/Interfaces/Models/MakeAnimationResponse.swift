//
//  MakeAnimationResponse.swift
//  NetworkProvider
//
//  Created by chminii on 3/4/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import ADResources
import UIKit

public enum RenderingType: String {
  case ping = "PING"
  case error = "ERROR"
  case running = "RUNNING"
  case fullJob = "FULL_JOB"
  case complete = "COMPLETE"
}

public struct MakeAnimationResponse: Equatable {
  public let type: RenderingType
  public let message: String

  public init(
    type: RenderingType,
    message: String
  ) {
    self.type = type
    self.message = message
  }
}

extension MakeAnimationResponse {
  public static func error() -> MakeAnimationResponse {
    return MakeAnimationResponse(
      type: .error,
      message: "render error"
    )
  }

  public static func running() -> MakeAnimationResponse {
    return MakeAnimationResponse(
      type: .running,
      message: "render running"
    )
  }

  public static func fullJob() -> MakeAnimationResponse {
    return MakeAnimationResponse(
      type: .fullJob,
      message: "render full job"
    )
  }

  public static func complete() -> MakeAnimationResponse {
    return MakeAnimationResponse(
      type: .complete,
      message: "render complete"
    )
  }
}
