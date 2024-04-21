//
//  MakeADProvider.swift
//  NetworkProvider
//
//  Created by minii on 2023/10/11.
//  Copyright © 2023 chminipark. All rights reserved.
//

import ADComposableArchitecture
import NetworkProviderInterfaces

public enum MakeADProvider: DependencyKey {
  public static let liveValue: any MakeADProviderProtocol = MakeADProviderImpl()
  public static let testValue: any MakeADProviderProtocol = TestMakeADProviderImpl()
}
