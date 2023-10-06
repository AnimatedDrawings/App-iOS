//
//  Extension+TCA.swift
//  ThirdPartyLib
//
//  Created by minii on 2023/09/14.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public protocol ADUI: View {
  associatedtype MyFeature: Reducer
  associatedtype MyViewStore = ViewStoreOf<MyFeature>
  associatedtype MyStore = StoreOf<MyFeature>
}
