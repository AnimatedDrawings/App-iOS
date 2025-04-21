import GoogleMobileAds
import SwiftUI
import ConfigureAnimationFeatures

// RewardAdView: 보상 광고를 표시하는 SwiftUI 뷰입니다.
public struct RewardAdView: View {
  @StateObject private var adManager = RewardAdManager()

  public var body: some View {
    VStack {
      Button(action: {
        adManager.showAd()
      }) {
        Text("보상 광고 보기")
          .foregroundColor(.white)
          .padding()
          .background(adManager.isAdReady ? Color.blue : Color.gray)
          .cornerRadius(8)
      }
      .disabled(!adManager.isAdReady)
    }
    .padding()
    .onAppear {
      adManager.loadAd()
    }
  }
}

// RewardAdManager: 보상 광고의 로드 및 표시를 관리하는 클래스입니다.
class RewardAdManager: NSObject, ObservableObject {
  @Published var rewardedAd: RewardedAd?
  @Published var isAdReady = false

  override init() {
    super.init()
    loadAd()
  }

  // 보상 광고를 로드합니다.
  func loadAd() {
    let request = Request()
    let adUnitID = rederingADUnitID
    RewardedAd.load(
      with: adUnitID, request: request,
      completionHandler: { [weak self] (ad, error) in
        guard let self = self else { return }
        if let error = error {
          print("보상 광고 로드 실패: \(error.localizedDescription)")
          self.isAdReady = false
          return
        }
        self.rewardedAd = ad
        self.rewardedAd?.fullScreenContentDelegate = self
        self.isAdReady = true
        print("보상 광고 준비 완료")
      })
  }

  // 보상 광고를 표시합니다.
  func showAd() {
    guard let ad = rewardedAd else {
      print("보상 광고가 준비되지 않았습니다.")
      loadAd()
      return
    }
    if let windowScene = UIApplication.shared.connectedScenes
      .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
      let rootVC = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController
    {
      ad.present(
        from: rootVC,
        userDidEarnRewardHandler: { [weak self] in
          let reward = ad.adReward
          print("사용자에게 보상: \(reward.amount) \(reward.type)")
          // 추가 보상 처리 로직을 여기에 작성할 수 있습니다.
          self?.rewardedAd = nil
          self?.isAdReady = false
        })
    } else {
      print("루트 뷰 컨트롤러를 찾을 수 없습니다.")
    }
  }
}

// MARK: - GADFullScreenContentDelegate 구현
extension RewardAdManager: FullScreenContentDelegate {
  func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
    print("보상 광고 종료됨.")
    loadAd()  // 광고 종료 시 새로운 광고를 로드합니다.
  }

  func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
    print("보상 광고 제시 실패: \(error.localizedDescription)")
    loadAd()
  }
}
