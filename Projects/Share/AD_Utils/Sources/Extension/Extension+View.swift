//
//  Extension+View.swift
//  AD_Utils
//
//  Created by minii on 2023/05/30.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

public extension View {
  @ViewBuilder
  func `if`<T: View, U: View>(
    _ condition: Bool,
    then modifierT: (Self) -> T,
    else modifierU: (Self) -> U
  ) -> some View {
    if condition { modifierT(self) }
    else { modifierU(self) }
  }
}
