#import <React/RCTViewManager.h>
#import <React/RCTUIManager.h>
#import <React/RCTBridge.h>

@interface RCT_EXTERN_MODULE(BannerAdView, RCTViewManager)

RCT_EXPORT_VIEW_PROPERTY(onAdLoaded, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdLoadFailed, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdClicked, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(placementUid, NSString *)
RCT_EXPORT_VIEW_PROPERTY(shouldLoadAd, BOOL)
RCT_EXPORT_VIEW_PROPERTY(adSize, NSString *)

@end 