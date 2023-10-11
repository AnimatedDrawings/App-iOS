//
//  ReloadViewModifier.swift
//  AD_Utils
//
//  Created by minii on 2023/07/12.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public extension View {
  func reload(_ trigger: some Hashable) -> some View {
    self.id(trigger)
  }
}
