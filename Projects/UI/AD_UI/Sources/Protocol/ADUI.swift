//
//  ADUI.swift
//  AD_UI
//
//  Created by minii on 2023/09/04.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

protocol ADUI: View {
  associatedtype MyFeature: Reducer
  associatedtype MyViewStore = ViewStore<MyFeature.State, MyFeature.Action>

  var store: StoreOf<MyFeature> { get }
}
