#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <React/RCTUIManager.h>
#import <AdWhaleSDK/AdWhaleSDK.h>

@interface BannerAdViewContainer : UIView <AdWhaleBannerDelegate>
@property (nonatomic, strong) AdWhaleBannerAd *bannerView;
@property (nonatomic, copy) RCTBubblingEventBlock onAdLoaded;
@property (nonatomic, copy) RCTBubblingEventBlock onAdLoadFailed;
@property (nonatomic, copy) RCTBubblingEventBlock onAdClicked;
@property (nonatomic, copy) NSString *adSize;
@property (nonatomic, copy) NSString *placementUid;
@property (nonatomic, assign) BOOL shouldLoadAd;
@end

@implementation BannerAdViewContainer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _adSize = @"BANNER320x50";
        _placementUid = @"";
        _shouldLoadAd = NO;
    }
    return self;
}

- (void)setAdSize:(NSString *)adSize {
    _adSize = adSize;
    [self updateAdSize];
}

- (void)setPlacementUid:(NSString *)placementUid {
    _placementUid = placementUid;
    [self.bannerView setAdUnitID:placementUid];
}

- (void)setShouldLoadAd:(BOOL)shouldLoadAd {
    _shouldLoadAd = shouldLoadAd;
    if (shouldLoadAd) {
        [self loadAd];
    }
}

- (void)updateAdSize {
    if (!self.bannerView) return;
    CGFloat width = 320;
    CGFloat height = 50;
    if ([_adSize isEqualToString:@"BANNER320x100"]) height = 100;
    else if ([_adSize isEqualToString:@"BANNER300x250"]) height = 250;
    CGRect frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - width) / 2, 0, width, height);
    self.bannerView.frame = frame;
    if ([_adSize isEqualToString:@"BANNER320x50"]) [self.bannerView setAdSize:AdWhaleAdSizeBanner];
    else if ([_adSize isEqualToString:@"BANNER320x100"]) [self.bannerView setAdSize:AdWhaleAdSizeLargeBanner];
    else if ([_adSize isEqualToString:@"BANNER300x250"]) [self.bannerView setAdSize:AdWhaleAdSizeMediumRectangle];
}

- (void)loadAd {
    if (!self.bannerView) {
        CGFloat width = 320;
        CGFloat height = 50;
        if ([_adSize isEqualToString:@"BANNER320x100"]) height = 100;
        else if ([_adSize isEqualToString:@"BANNER300x250"]) height = 250;
        CGRect frame = CGRectMake((UIScreen.mainScreen.bounds.size.width - width) / 2, 0, width, height);
        self.bannerView = [[AdWhaleBannerAd alloc] initWithFrame:frame];
        [self addSubview:self.bannerView];
        [self updateAdSize];
        [self.bannerView setAdUnitID:self.placementUid ?: @""];
        [self.bannerView setRootViewController:RCTPresentedViewController()];
        [self.bannerView setDelegate:self];
    }
    [self.bannerView load];
}

// MARK: - AdWhaleBannerDelegate
- (void)bannerViewDidReceiveAd:(AdWhaleBannerAd *)bannerView {
    if (self.onAdLoaded) self.onAdLoaded(@{});
}
- (void)bannerView:(AdWhaleBannerAd *)bannerView didFailToReceiveAdWithError:(NSError *)error {
    if (self.onAdLoadFailed) self.onAdLoadFailed(@{@"statusCode": @0, @"message": error.localizedDescription ?: @""});
}
- (void)bannerViewDidRecordImpression:(AdWhaleBannerAd *)bannerView {}
- (void)bannerViewWillPresentScreen:(AdWhaleBannerAd *)bannerView {
    if (self.onAdClicked) self.onAdClicked(@{});
}
- (void)bannerViewWillDismissScreen:(AdWhaleBannerAd *)bannerView {}
- (void)bannerViewDidDismissScreen:(AdWhaleBannerAd *)bannerView {}

@end

@interface BannerAdView : RCTViewManager
@end

@implementation BannerAdView
RCT_EXPORT_MODULE()

RCT_EXPORT_VIEW_PROPERTY(onAdLoaded, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdLoadFailed, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onAdClicked, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(adSize, NSString)
RCT_EXPORT_VIEW_PROPERTY(placementUid, NSString)
RCT_EXPORT_VIEW_PROPERTY(shouldLoadAd, BOOL)

- (UIView *)view {
    return [[BannerAdViewContainer alloc] init];
}
@end 
