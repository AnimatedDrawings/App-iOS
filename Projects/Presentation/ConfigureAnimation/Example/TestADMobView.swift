//
//  TestADMobView.swift
//  ConfigureAnimationExample
//
//  Created by minii on 2025/05/18.
//

import AdmobManager
import ConfigureAnimationFeatures
import GoogleMobileAds
import SwiftUI

struct TestADMobView: View {
  @State private var isShowingAlert = false
  @State private var alertMessage = ""
//  private let admobManager = TestAdmobManagerImpl()
  private let admobManager = AdmobManagerImpl()

  var body: some View {
    VStack {
      Button("리워드 광고 보기") {
        Task {
          let result = await admobManager.getRewardADResult()
          switch result {
          case .success:
            alertMessage = "🎉 리워드 획득 성공"
          case .failure:
            alertMessage = "😢 리워드 획득 실패"
          }
          isShowingAlert = true
        }
      }
      .padding()
      .buttonStyle(.borderedProminent)

      Button("광고 인스펙터 보기") {
        let rootVC = UIApplication.shared.rootViewController
        MobileAds.shared.presentAdInspector(from: rootVC) { error in
          print("광고 인스펙터 보기 오류: \(error)")
        }
      }
    }
    .alert(alertMessage, isPresented: $isShowingAlert) {
      Button("확인", role: .cancel) {}
    }
  }
}

struct TestADMobView_Previews: PreviewProvider {
  static var previews: some View {
    TestADMobView()
  }
}
