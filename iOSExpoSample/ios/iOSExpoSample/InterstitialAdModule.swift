import Foundation
import AdWhaleSDK
import React

@objc(InterstitialAdModule)
class InterstitialAdModule: RCTEventEmitter {
  private var interstitialAd: AdWhaleInterstitialAd?
  
  override func supportedEvents() -> [String]! {
    return [
      "onInterstitialAdLoaded",
      "onInterstitialAdFailedToLoad",
      "onInterstitialAdFailedToShow",
      "onInterstitialAdWillPresent",
      "onInterstitialAdDismissed"
    ]
  }

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }

  @objc
  func loadAd(_ adUnitId: String, resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.async {
      print("[adwhale] [sample Native] 전면 광고 로드 시작")
      self.interstitialAd = AdWhaleInterstitialAd()
      self.interstitialAd?.interstitialDelegate = self
      self.interstitialAd?.load(adUnitId)
      resolve(nil)
    }
  }

  @objc
  func showAd(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: @escaping RCTPromiseRejectBlock) {
    DispatchQueue.main.async {
      if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
        print("[adwhale] [sample Native] 전면 광고 표시 시도")
        self.interstitialAd?.show(rootViewController)
        resolve(nil)
      } else {
        print("[adwhale] [sample Native] Root view controller를 찾을 수 없음")
        reject("ERROR", "Root view controller not found", nil)
      }
    }
  }
}

extension InterstitialAdModule: AdWhaleInterstitialDelegate {
  func adDidReceiveInterstitialAd(_ ad: AdWhaleInterstitialAd) {
    print("[adwhale] [sample Native] 전면 광고 로드 성공")
    interstitialAd = ad
    sendEvent(withName: "onInterstitialAdLoaded", body: nil)
  }

  func adDidFailToReceiveInterstitialAdWithError(_ error: Error) {
    print("[adwhale] [sample Native] 전면 광고 로드 실패: \(error.localizedDescription)")
    sendEvent(withName: "onInterstitialAdFailedToLoad", body: ["error": error.localizedDescription])
  }

  func ad(_ ad: AdWhaleInterstitialAd, didFailToPresentInterstitialAdWithError error: Error) {
    print("[adwhale] [sample Native] 전면 광고 표시 실패: \(error.localizedDescription)")
    sendEvent(withName: "onInterstitialAdFailedToShow", body: ["error": error.localizedDescription])
  }

  func adWillPresentInterstitialAd(_ ad: AdWhaleInterstitialAd) {
    print("[adwhale] [sample Native] 전면 광고가 표시될 예정")
    sendEvent(withName: "onInterstitialAdWillPresent", body: nil)
  }

  func adDidDismissInterstitialAd(_ ad: AdWhaleInterstitialAd) {
    print("[adwhale] [sample Native] 전면 광고가 닫힘")
    sendEvent(withName: "onInterstitialAdDismissed", body: nil)
  }
} 
 
