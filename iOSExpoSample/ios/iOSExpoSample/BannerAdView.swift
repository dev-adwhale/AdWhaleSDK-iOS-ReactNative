import UIKit
import AdWhaleSDK
import React

@objc(BannerAdView)
class BannerAdView: RCTViewManager {
    override func view() -> UIView! {
        return BannerAdViewContainer()
    }
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
}

@objc(BannerAdViewContainer)
class BannerAdViewContainer: UIView {
    private var bannerView: AdWhaleBannerAd?
    @objc var adSize: String = "BANNER320x50" {
        didSet {
            updateAdSize()
        }
    }
    @objc var placementUid: String = "" {
        didSet {
            bannerView?.setAdUnitID(placementUid)
        }
    }
    @objc var shouldLoadAd: Bool = false {
        didSet {
            if shouldLoadAd {
                loadAd()
            }
        }
    }
    
    @objc var onAdLoaded: RCTDirectEventBlock?
    @objc var onAdLoadFailed: RCTDirectEventBlock?
    @objc var onAdClicked: RCTDirectEventBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBannerAd()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBannerAd()
    }
    
    private func setupBannerAd() {
        let screenWidth = UIScreen.main.bounds.width
        let bannerWidth: CGFloat = 320
        let xPosition = (screenWidth - bannerWidth) / 2
        
        let frame = CGRect(x: xPosition,
                          y: 0,
                          width: bannerWidth,
                          height: getBannerHeight(for: adSize))
        
        bannerView = AdWhaleBannerAd(frame: frame)
        if let bannerView = bannerView {
            addSubview(bannerView)
            updateAdSize()
            bannerView.setAdUnitID(placementUid)
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootViewController = windowScene.windows.first?.rootViewController {
                bannerView.setRootViewController(rootViewController)
            }
            
            bannerView.setDelegate(self)
        }
    }
    
    private func getBannerHeight(for size: String) -> CGFloat {
        switch size {
        case "BANNER320x50":
            return 50
        case "BANNER320x100":
            return 100
        case "BANNER300x250":
            return 250
        default:
            return 50
        }
    }
    
    private func updateAdSize() {
        guard let bannerView = bannerView else { return }
        
        // 배너 뷰의 크기를 새로운 사이즈에 맞게 업데이트
        let screenWidth = UIScreen.main.bounds.width
        let bannerWidth: CGFloat = 320
        let xPosition = (screenWidth - bannerWidth) / 2
        let newHeight = getBannerHeight(for: adSize)
        
        bannerView.frame = CGRect(x: xPosition,
                                y: bannerView.frame.origin.y,
                                width: bannerWidth,
                                height: newHeight)
        
        switch adSize {
        case "BANNER320x50":
            bannerView.setAdSize(.banner)
            break;
        case "BANNER320x100":
            bannerView.setAdSize(.largeBanner)
            break;
        case "BANNER300x250":
            bannerView.setAdSize(.mediumRectangle)
            break
        default:
            bannerView.setAdSize(.banner)
        }
    }
    
    private func loadAd() {
        bannerView?.setAdUnitID(placementUid)
        bannerView?.load()
    }
}

// MARK: - BannerAd Delegate
extension BannerAdViewContainer: AdWhaleBannerDelegate {
    func bannerViewDidReceiveAd(_ bannerView: AdWhaleSDK.AdWhaleBannerAd) {
        print("[adwhale] [sample Native] 배너 광고 로드 성공")
        onAdLoaded?([:])
    }
    
    func bannerView(_ bannerView: AdWhaleSDK.AdWhaleBannerAd, didFailToReceiveAdWithError error: Error) {
        print("[adwhale] [sample Native] 배너 광고 로드 실패: \(error.localizedDescription)")
        onAdLoadFailed?([
            "statusCode": 0,
            "message": error.localizedDescription
        ])
    }
    
    func bannerViewDidRecordImpression(_ bannerView: AdWhaleSDK.AdWhaleBannerAd) {
        print("[adwhale] [sample Native] 배너 광고 노출")
    }
    
    func bannerViewWillPresentScreen(_ bannerView: AdWhaleSDK.AdWhaleBannerAd) {
        print("[adwhale] [sample Native] 배너 광고 클릭")
        onAdClicked?([:])
    }
    
    func bannerViewWillDismissScreen(_ bannerView: AdWhaleSDK.AdWhaleBannerAd) {
        print("[adwhale] [sample Native] 배너 광고 화면 닫힘 예정")
    }
    
    func bannerViewDidDismissScreen(_ bannerView: AdWhaleSDK.AdWhaleBannerAd) {
        print("[adwhale] [sample Native] 배너 광고 화면 닫힘")
    }
} 
