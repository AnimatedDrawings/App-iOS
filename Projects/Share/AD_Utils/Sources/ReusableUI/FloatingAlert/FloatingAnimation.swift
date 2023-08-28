//
//  FloatingAnimation.swift
//  AD_Utils
//
//  Created by minii on 2023/08/28.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

extension View {
  func addFloatingAnimation() -> some View {
    self.modifier(FloatingAnimation())
  }
}

struct FloatingAnimation: ViewModifier {
  func body(content: Content) -> some View {
    content
  }
}

struct Previews_FloatingAnimation: View {
  var body: some View {
    HStack {
      CheckList {
        
      }
    }
  }
}

struct FloatingAnimation_Previews: PreviewProvider {
  static var previews: some View {
    Previews_FloatingAnimation()
  }
}
