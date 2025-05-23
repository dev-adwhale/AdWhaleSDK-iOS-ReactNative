#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(AdWhaleSettingModule, NSObject)

RCT_EXTERN_METHOD(showAdInspector:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(showGDPR:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end 