//
//  ADNetworkProvider.swift
//  NetworkProvider
//
//  Created by chminii on 3/4/25.
//  Copyright © 2025 chminipark. All rights reserved.
//

import ADComposableArchitecture
import NetworkProviderInterfaces

public enum ADNetworkProvider: DependencyKey {
  public static let liveValue: any ADNetworkProviderProtocol = ADNetworkProviderImpl()
  public static let testValue: any ADNetworkProviderProtocol = TestADNetworkProviderImpl()
}
