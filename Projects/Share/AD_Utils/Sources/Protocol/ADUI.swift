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
  associatedtype MyReducer: ReducerProtocol
  associatedtype MyViewStore = ViewStore<MyReducer.State, MyReducer.Action>

  var store: StoreOf<MyReducer> { get }
}
