
#import "RNAlibcSdk.h"
#import "AlibcSdkBridge.h"

#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import <React/RCTLog.h>


#define NOT_LOGIN (@"not login")

@implementation RNAlibcSdk

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(init: (NSString *)pid forceH5:(BOOL)forceH5 resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[AlibcSdkBridge sharedInstance] init:pid forceH5:forceH5 resolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(login: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[AlibcSdkBridge sharedInstance] login:resolve rejecter:reject];
}
RCT_EXPORT_METHOD(isLogin: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[AlibcSdkBridge sharedInstance] isLogin:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(getUser: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[AlibcSdkBridge sharedInstance] getUser:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(logout: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[AlibcSdkBridge sharedInstance] logout:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(show: (NSDictionary *)param open:(NSString *)open resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject){
    [[AlibcSdkBridge sharedInstance] show:param open:open resolver:resolve rejecter:reject];
}


@end
  
