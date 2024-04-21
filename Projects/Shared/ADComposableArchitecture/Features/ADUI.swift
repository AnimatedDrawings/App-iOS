//
//  ADUI.swift
//  ADComposableArchitecture
//
//  Created by chminii on 3/11/24.
//  Copyright © 2024 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public protocol ADUI: View {
  associatedtype MyFeature: Reducer
  associatedtype MyViewStore = ViewStoreOf<MyFeature>
  associatedtype MyStore = StoreOf<MyFeature>
}
