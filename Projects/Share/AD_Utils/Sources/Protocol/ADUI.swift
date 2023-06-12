//
//  ADUI.swift
//  AD_Utils
//
//  Created by minii on 2023/06/09.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public protocol ADUI: View {
  associatedtype MyStore: ReducerProtocol
  associatedtype MyViewStore = ViewStore<MyStore.State, MyStore.Action>

  var store: StoreOf<MyStore> { get }
}
