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
  associatedtype MyFeature: Reducer
  associatedtype MyViewStore = ViewStore<MyFeature.State, MyFeature.Action>

  var store: StoreOf<MyFeature> { get }
}
