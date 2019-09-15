//
//  ALiTradeSDKShareParam.m
//  NBSDK
//
//  Created by com.alibaba on 16/5/31.
//  Copyright © 2016年 com.alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALiTradeSDKShareParam.h"
@interface ALiTradeSDKShareParam()

@end

@implementation ALiTradeSDKShareParam
+ (instancetype)sharedInstance
{
    static ALiTradeSDKShareParam* instance ;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ALiTradeSDKShareParam alloc] init];
    });
    return instance;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        self.customParams = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"hello",@"pvid",@"world",@"scm",@"vedio",@"page",@"youku",@"subplat",@"trade",@"label",@"ling",@"puid",@"xxxxx",@"pguid",nil];

//        self.customParams=nil;
        self.externParams = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"taobaoH5", @"_viewType",@"tag1",@"isv_code",@"xxxxxxxxxx",@"ybhpss",nil];

//        self.taoKeParams = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"mm_100713040_22792955_75330474", @"pid",@"",@"unionId",@"", @"subPid",nil];
//        self.globalTaoKeParams = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"mm_100713040_22792955_75330474", @"pid",@"",@"unionId",@"", @"subPid",nil];
        
        self.taoKeParams = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"mm_100713040_22792955_75330474", @"pid",@"",@"unionId",@"mm_10011550_0_0", @"subPid", @"29932014",@"adzoneId",@"{\"sellerId\":2241885069,\"taokeAppkey\":23281718}",@"extParams",nil];
        self.globalTaoKeParams = [[NSMutableDictionary alloc]initWithObjectsAndKeys:@"mm_100713040_22792955_75330474", @"pid",@"",@"unionId",@"", @"subPid",@"", @"adzoneId",nil];
        self.openType=0;
        self.linkKey=0;
        self.isNeedPush=NO;
        self.isBindWebview=NO;
        self.NativeFailMode=0;
        self.isUseTaokeParam=YES;
        self.isNeedCustomFailMode = NO;

    }
    return self;
}



@end
