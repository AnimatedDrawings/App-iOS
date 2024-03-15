//
//  ConfigureAnimationProvider.swift
//  NetworkProvider
//
//  Created by minii on 2023/10/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture

public enum ConfigureAnimationProvider: DependencyKey {
  public static let liveValue: any ConfigureAnimationProviderProtocol = ConfigureAnimationProviderImpl()
  public static let testValue: any ConfigureAnimationProviderProtocol = TestConfigureAnimationProviderImpl()
}
