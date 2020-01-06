//
//  AlibcSdkBridge.m
//  RNAlibcSdk
//
//  Created by et on 17/4/18.
//  Copyright © 2017年 Facebook. All rights reserved.
//

#import "AlibcSdkBridge.h"
#import "AlibcWebView.h"
#import <React/RCTLog.h>
#import <React/RCTEventDispatcher.h>
#import <React/RCTUtils.h>
#import <React/RCTImageLoader.h>
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
#import "ALiTradeSDKShareParam.h"
//#import "AlibcTradePageFactory.h"
#import <AlibcTradeSDK/AlibcTradePageFactory.h>
#import "ALiTradeWebViewController.h"
#import "TaobaoOAuthViewController.h"
#import "UIKit/UIKit.h"


//#import <Foundation/Foundation.h>
//
//#import "ALiTradeTestData.h"
//
//#import <AlibcTradeSDK/AlibcTradeService.h>
//#import <AlibcTradeSDK/AlibcTradePageFactory.h>




#define NOT_LOGIN (@"not login")

//@interface ALiTradeServiceAPIViewController()
//@property (nonatomic) OneSDKItemType itemType;
//@property (nonatomic, strong) ALiTradeTestData *tradeTestData;
//@end

static NSString *const kOpenURLNotification = @"RCTOpenURLNotification";

@interface AlibcSdkBridge ()
@property (nonatomic, copy) RCTPromiseResolveBlock payOrderResolve;

@end

@implementation AlibcSdkBridge {
    AlibcTradeTaokeParams *taokeParams;
    AlibcTradeShowParams *showParams;
//    navigationController *showParamss;
}

+ (instancetype) sharedInstance
{
    static AlibcSdkBridge *instance = nil;
    if (!instance) {
        instance = [[AlibcSdkBridge alloc] init];
    }
    return instance;
}
RCT_EXPORT_MODULE();
//- (void)init: (NSString *)pid forceH5:(BOOL)forceH5 resolver:(RCTPromiseResolveBlock)resolve
RCT_EXPORT_METHOD(init:(NSString *)pid forceH5:(BOOL)forceH5 resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件


    
    // 初始化AlibabaAuthSDK
    [[ALBBSDK sharedInstance] ALBBSDKInit];
    
    // 开发阶段打开日志开关，方便排查错误信息
    //默认调试模式打开日志,release关闭,可以不调用下面的函数
    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];
    // 百川平台基础SDK初始化，加载并初始化各个业务能力插件
//    [[AlibcTradeSDK sharedInstance] setDebugLogOpen:YES];//开发阶段打开日志开关，方便排查错误信息
    
    [[AlibcTradeSDK sharedInstance] setIsvVersion:@"2.2.2"];
    [[AlibcTradeSDK sharedInstance] setIsvAppName:@"baichuanDemo"];
    [[AlibcTradeSDK sharedInstance] asyncInitWithSuccess:^{
        resolve([NSNull null]);
    } failure:^(NSError *error) {
        NSDictionary *ret = @{@"code": @(error.code), @"msg":error.description};
        resolve(ret);
    }];
    // 配置全局的淘客参数
    //如果没有阿里妈妈的淘客账号,setTaokeParams函数需要调用
    taokeParams = [[AlibcTradeTaokeParams alloc] init];
    taokeParams.pid = pid;
    [[AlibcTradeSDK sharedInstance] setTaokeParams:taokeParams];
    
    showParams = [[AlibcTradeShowParams alloc] init];
    showParams.openType = AlibcOpenTypeAuto;
    
    //设置全局的app标识，在电商模块里等同于isv_code
    //没有申请过isv_code的接入方,默认不需要调用该函数
    //[[AlibcTradeSDK sharedInstance] setISVCode:@"your_isv_code"];
    
    // 设置全局配置，是否强制使用h5
//    [[AlibcTradeSDK sharedInstance] setIsForceH5:YES];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (BOOL)requiresMainQueueSetup {
    return YES;
}
- (AlibcOpenType)openType{
    
    AlibcOpenType openType=AlibcOpenTypeAuto;
    switch ([ALiTradeSDKShareParam sharedInstance].openType) {
        case 0:
            openType=AlibcOpenTypeAuto;
            break;
        case 1:
            openType=AlibcOpenTypeNative;
            break;
        default:
            break;
    }
    return openType;
}




//- (void)login: (RCTPromiseResolveBlock)resolve
RCT_EXPORT_METHOD(login: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ALBBSDK sharedInstance] auth:[UIApplication sharedApplication].delegate.window.rootViewController
                   successCallback:^(ALBBSession *session) {
                       ALBBUser *s = [session getUser];
                       NSDictionary *ret = @{@"nick": s.nick, @"avatarUrl":s.avatarUrl, @"openId":s.openId, @"openSid":s.openSid,@"err":@"1"};
                       resolve(ret);
                   }
                   failureCallback:^(ALBBSession *session, NSError *error) {
                       NSDictionary *ret = @{@"code": @(error.code), @"msg":error.description,@"err":@"0"};
                       resolve(ret);
                   }
     ];
}
RCT_EXPORT_METHOD(isLogin: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
//- (void)isLogin: (RCTResponseSenderBlock)callback
{
    bool isLogin = [[ALBBSession sharedInstance] isLogin];
    resolve([NSNumber numberWithBool: isLogin]);
}
RCT_EXPORT_METHOD(getUser: resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
//- (void)getUser: (RCTResponseSenderBlock)callback
{
    if([[ALBBSession sharedInstance] isLogin]){
        ALBBUser *s = [[ALBBSession sharedInstance] getUser];
        NSDictionary *ret = @{@"nick": s.nick, @"avatarUrl":s.avatarUrl, @"openId":s.openId, @"openSid":s.openSid,@"err":@"1"};
        resolve(ret);
    } else {
        
        resolve([NSNull null]);
//        resolve(NOT_LOGIN);
    }
}

//- (void)logout: (RCTResponseSenderBlock)callback
RCT_EXPORT_METHOD(logout: (RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [[ALBBSDK sharedInstance] logout];
    resolve([NSNull null]);
}

//- (void)show: (NSDictionary *)param callback: (RCTResponseSenderBlock)callback
RCT_EXPORT_METHOD(show: (NSDictionary *)param open:(NSString *)open resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    
    NSString *type = param[@"type"];
    showParams.openType = AlibcNativeFailModeNone;
    if([open isEqualToString:@"None"]){
        showParams.openType = AlibcNativeFailModeNone;
    } else if([open isEqualToString:@"H5"]){
        showParams.openType = AlibcOpenTypeAuto;
    } else if([open isEqualToString:@"Auto"]){
        showParams.openType = AlibcOpenTypeAuto;
    } else if([open isEqualToString:@"Native"]){
        showParams.openType = AlibcOpenTypeNative;
    } else if([open isEqualToString:@"DownloadPage"]){
        showParams.openType = AlibcNativeFailModeJumpDownloadPage;
    }
    NSString *bizCode = nil;
    id<AlibcTradePage> page;
    if ([type isEqualToString:@"detail"]) {
        bizCode = @"detail";
        page = [AlibcTradePageFactory itemDetailPage:(NSString *)param[@"payload"]];
    } else if ([type isEqualToString:@"url"]) {
        page = [AlibcTradePageFactory page:(NSString *)param[@"payload"]];
        ALiTradeWebViewController* myView = [[ALiTradeWebViewController alloc] init];
//        [[AlibcTradeSDK sharedInstance].tradeService show: myView webView: myView.webView page:page showParams:nil taoKeParams: nil trackParam: trackParam tradeProcessSuccessCallback:nil tradeProcessFailedCallback:nil];
        
        
        NSInteger res  =  [[AlibcTradeSDK sharedInstance].tradeService
         openByUrl:param[@"payload"]
         identity:@"trade"
         webView:myView.webView
         parentController:myView
         showParams:showParams
         taoKeParams:taokeParams
         trackParam:nil
         tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {

         } tradeProcessFailedCallback:^(NSError * _Nullable error) {

         }
         ];
        if (res == 1) {
            UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;

            [appRootVC presentViewController:myView animated:YES completion:nil];

        }
        
//        page = [ALiTradePageFactory page: (NSString *)param[@"payload"]];
//        [self _openByUrl:(NSString *)param[@"payload"]];
//        [self _openByUrl:page];
        return;
    } else if ([type isEqualToString:@"shop"]) {
        bizCode = @"shop";
        page = [AlibcTradePageFactory shopPage:(NSString *)param[@"payload"]];
    } else if ([type isEqualToString:@"orders"]) {
        bizCode = @"orders";
        NSDictionary *payload = (NSDictionary *)param[@"payload"];
        page = [AlibcTradePageFactory myOrdersPage:[payload[@"orderType"] integerValue] isAllOrder:[payload[@"isAllOrder"] boolValue]];
    } else if ([type isEqualToString:@"addCard"]) {
        bizCode = @"addCard";
        page = [AlibcTradePageFactory addCartPage:(NSString *)param[@"payload"]];
    } else if ([type isEqualToString:@"mycard"]) {
        bizCode = @"cart";
        page = [AlibcTradePageFactory myCartsPage];
    } else {
        RCTLog(@"not implement");
        return;
    }
    
    [self _show:page BizCode:(NSString *)bizCode resolver:resolve rejecter:reject];
}

//- (void)_show: (id<AlibcTradePage>)page callback: (RCTResponseSenderBlock)callback
RCT_EXPORT_METHOD(_show: (id<AlibcTradePage>)page BizCode:(NSString *)bizCode resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
//    BOOL isNeedPush=[ALiTradeSDKShareParam sharedInstance].isNeedPush;
//    BOOL isBindWebview=[ALiTradeSDKShareParam sharedInstance].isBindWebview;
    
    showParams.isNeedPush=NO;
    showParams.nativeFailMode=AlibcNativeFailModeJumpH5;
//    showParams.isNeedCustomNativeFailMode = [ALiTradeSDKShareParam sharedInstance].isNeedCustomFailMode;
//    showParams.linkKey=@"taobao";
    showParams.openType = AlibcOpenTypeAuto;
    showParams.openType = AlibcNativeFailModeJumpH5;
    showParams.isNeedCustomNativeFailMode = YES;
//    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
//    ALiTradeWebViewController* view = [[ALiTradeWebViewController alloc] init];
    TaobaoOAuthViewController* view = [[TaobaoOAuthViewController alloc] init];
//    showParams.isNeedPush = YES;
    NSInteger res  =  [[AlibcTradeSDK sharedInstance].tradeService
     openByBizCode:bizCode
     page:page
     webView:view.myWebView
     parentController:view
     showParams:showParams// 跳转方式
     taoKeParams:taokeParams  //配置 阿里妈妈信息
     trackParam:nil //[self customParam]
     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
         if (result.result == AlibcTradeResultTypeAddCard) {
             NSDictionary *ret = @{@"type": @"card",@"err":@"1"};
             resolve(ret);
         } else if (result.result == AlibcTradeResultTypePaySuccess) {
             NSDictionary *ret = @{@"type": @"pay", @"orders": result.payResult.paySuccessOrders,@"err":@"1"};
             resolve(ret);
         }
     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
         NSDictionary *ret = @{@"type": @"error", @"code": @(error.code), @"msg":error.description,@"err":@"1"};
         resolve(ret);
     }
    ];
    
    if (res == 1) {
        UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;

        [appRootVC presentViewController:view animated:YES completion:nil];

    }
    
    
    
    //        [self presentViewController:view animated:YES completion:nil];
    //        [self presentViewController:view animated:YES completion:nil];
    //        [self.navigationController pushViewController:view animated:YES];
}
- (void)showInWebView: (AlibcWebView *)webView url:(NSString *)url param:(NSDictionary *)param
{
    NSString *type = param[@"type"];
    id<AlibcTradePage> page;
    if ([type isEqualToString:@"detail"]) {
        page = [AlibcTradePageFactory itemDetailPage:(NSString *)param[@"payload"]];
    } else if ([type isEqualToString:@"url"]) {
        page = [AlibcTradePageFactory page:(NSString *)param[@"payload"]];
    } else if ([type isEqualToString:@"shop"]) {
        page = [AlibcTradePageFactory shopPage:(NSString *)param[@"payload"]];
    } else if ([type isEqualToString:@"orders"]) {
        NSDictionary *payload = (NSDictionary *)param[@"payload"];
        page = [AlibcTradePageFactory myOrdersPage:[payload[@"orderType"] integerValue] isAllOrder:[payload[@"isAllOrder"] boolValue]];
    } else if ([type isEqualToString:@"addCard"]) {
        page = [AlibcTradePageFactory addCartPage:(NSString *)param[@"payload"]];
    } else if ([type isEqualToString:@"mycard"]) {
        page = [AlibcTradePageFactory myCartsPage];
    } else {
        RCTLog(@"not implement");
        return;
    }
    
    [self _showInWebView:webView url:url page:page];
}



-(NSDictionary *)customParam{
    NSDictionary *customParam=[NSDictionary dictionaryWithDictionary:[ALiTradeSDKShareParam sharedInstance].customParams];
    return customParam;
    
}

RCT_EXPORT_METHOD(_openByUrl:url)
{
    ALiTradeWebViewController* view = [[ALiTradeWebViewController alloc] init];
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    [[AlibcTradeSDK sharedInstance].tradeService
     openByUrl:url
     identity:@"trade"
     webView:nil
     parentController:self
     showParams:showParams
     taoKeParams:taokeParams
     trackParam:nil
     tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
         if (result.result == AlibcTradeResultTypeAddCard) {
             ((AlibcWebView *)view.webView).onTradeResult(@{
                                                       @"type": @"card",
                                                       });
         } else if (result.result == AlibcTradeResultTypePaySuccess) {
             ((AlibcWebView *)view.webView).onTradeResult(@{
                                                       @"type": @"pay",
                                                       @"orders": result.payResult.paySuccessOrders,
                                                       });
         }
     } tradeProcessFailedCallback:^(NSError * _Nullable error) {
         ((AlibcWebView *)view.webView).onTradeResult(@{
                                                   @"type": @"error",
                                                   @"code": @(error.code),
                                                   @"msg": error.description,
                                                   });
     }
     ];
}



- (void)_showInWebView: (UIWebView *)webView url:url page:(id<AlibcTradePage>)page
{
    id<AlibcTradeService> service = [AlibcTradeSDK sharedInstance].tradeService;
    [[AlibcTradeSDK sharedInstance].tradeService
        openByUrl:url
        identity:@"trade"
        webView:webView
        parentController:self
        showParams:showParams
        taoKeParams:taokeParams
        trackParam:nil
         tradeProcessSuccessCallback:^(AlibcTradeResult * _Nullable result) {
             if (result.result == AlibcTradeResultTypeAddCard) {
                 ((AlibcWebView *)webView).onTradeResult(@{
                                                           @"type": @"card",
                                                           });
             } else if (result.result == AlibcTradeResultTypePaySuccess) {
                 ((AlibcWebView *)webView).onTradeResult(@{
                                                           @"type": @"pay",
                                                           @"orders": result.payResult.paySuccessOrders,
                                                           });
             }
         } tradeProcessFailedCallback:^(NSError * _Nullable error) {
             ((AlibcWebView *)webView).onTradeResult(@{
                                                       @"type": @"error",
                                                       @"code": @(error.code),
                                                       @"msg": error.description,
                                                       });
         }
     ];
}


- (void)handleOpenURL:(NSNotification *)notification {
    NSString *urlString = notification.userInfo[@"url"];
    NSURL *url = [NSURL URLWithString:urlString];
    if ([url.host isEqualToString:@"safepay"]) {
        __weak __typeof__(self) weakSelf = self;
        [AlipaySDK.defaultService processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"processOrderWithPaymentResult = %@", resultDic);
            if (weakSelf.payOrderResolve) {
                weakSelf.payOrderResolve(resultDic);
                weakSelf.payOrderResolve = nil;
            }
        }];
        
        [AlipaySDK.defaultService processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"processAuth_V2Result = %@", resultDic);
        }];
    }
}

RCT_EXPORT_METHOD(authWithInfo:(NSString *)infoStr
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    [AlipaySDK.defaultService auth_V2WithInfo:infoStr fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
        resolve(resultDic);
    }];
}

RCT_EXPORT_METHOD(pay:(NSString *)orderInfo
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    self.payOrderResolve = resolve;
    [AlipaySDK.defaultService payOrder:orderInfo fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
        resolve(resultDic);
    }];
}

RCT_EXPORT_METHOD(payInterceptorWithUrl:(NSString *)urlStr
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    [AlipaySDK.defaultService payInterceptorWithUrl:urlStr fromScheme:self.appScheme callback:^(NSDictionary *resultDic) {
        resolve(resultDic);
    }];
}

RCT_EXPORT_METHOD(getVersion:(RCTPromiseResolveBlock)resolve) {
    resolve(AlipaySDK.defaultService.currentVersion);
}

- (NSString *)appScheme {
    NSArray *urlTypes = NSBundle.mainBundle.infoDictionary[@"CFBundleURLTypes"];
    for (NSDictionary *urlType in urlTypes) {
        NSString *urlName = urlType[@"CFBundleURLName"];
        if ([urlName hasPrefix:@"alipay"]) {
            NSArray *schemes = urlType[@"CFBundleURLSchemes"];
            return schemes.firstObject;
        }
    }
    return nil;
}

@end
