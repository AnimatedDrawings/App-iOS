//
//  ConfigureAnimationProvider.swift
//  NetworkProvider
//
//  Created by minii on 2023/10/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import NetworkStorage
import UIKit
import DomainModel

public struct ConfigureAnimationProvider {
  public var add: @Sendable (String, ADAnimation) async throws -> ()
  public var download: @Sendable (String, ADAnimation) async throws -> (Data)
}

extension ConfigureAnimationProvider: DependencyKey {
  private static let storage = ConfigureAnimationStorage.shared
  
  public static let liveValue = Self(
    add: { ad_id, adAnimation in
      let response = try await storage.add(
        request: AddAnimationRequest(
          ad_id: ad_id,
          adAnimationDTO: adAnimation.toDTO()
        )
      )
    },
    
    download: { ad_id, adAnimation in
      let response = try await storage.download(
        request: DownloadAnimationRequest(
          ad_id: ad_id,
          adAnimationDTO: adAnimation.toDTO()
        )
      )
      
      return response
    }
  )
  
  public static let testValue = Self(
    add: { _, _ in },
    download: { _, _ in Data() }
  )
}
