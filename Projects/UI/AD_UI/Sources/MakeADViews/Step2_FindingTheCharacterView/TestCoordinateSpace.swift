//
//  TestCoordinateSpace.swift
//  AD_UI
//
//  Created by minii on 2023/06/03.
//  Copyright © 2023 chminipark. All rights reserved.
//

import SwiftUI

struct TestCoordinateSpace: View {
  @State var location = CGPoint.zero
  
  var body: some View {
    VStack {
      Color.red.frame(width: 300, height: 400)
        .overlay(circle)
      Text("Location: \(Int(location.x)), \(Int(location.y))")
    }
    .coordinateSpace(name: "stack")
  }
  
  var circle: some View {
    Circle()
      .frame(width: 25, height: 25)
      .gesture(drag)
      .padding(5)
      .position(location)
  }
  
  var drag: some Gesture {
    DragGesture(coordinateSpace: .named("stack"))
      .onChanged { info in location = info.location }
  }
}

struct TestCoordinateSpace_Previews: PreviewProvider {
  static var previews: some View {
    TestCoordinateSpace()
  }
}

public struct PublicTestCoordinateSpace: View {
  
  public init() {}
  
  public var body: some View {
      TestCoordinateSpace()
  }
}
