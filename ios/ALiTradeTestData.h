//
//  ALiTradeTestData.h
//  TaeSDKSample
//
//  Created by com.alibaba on 15/6/23.
//  Copyright (c) 2015年 com.taobao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ALiTradeTestData : NSObject

@property (nonatomic, strong) NSString *pageUrl;

@property (nonatomic, strong) NSString *taokePageUrl;
@property (nonatomic, strong) NSString *itemType;
@property (nonatomic, strong) NSString *realItemId;
@property (nonatomic, strong) NSString *shopId;

@property (nonatomic, strong) NSString *openItemId1;
@property (nonatomic, strong) NSString *skuId1;
@property (nonatomic, strong) NSString *openItemId2;
@property (nonatomic, strong) NSString *skuId2;

@property (nonatomic, strong) NSString *taoKePid;
@property (nonatomic, strong) NSString *taoKeUnionId;

@property (nonatomic, strong) NSString *promotionparam;
@property (nonatomic, strong) NSString *promotiontype;
@property (nonatomic, strong) NSString *eticketorderid;


/*!
 @brief ItemType可选值:淘宝宝贝、天猫宝贝
 !*/
typedef NS_ENUM(NSInteger, OneSDKItemType)
{
    OneSDKItemType_TAOBAO1      = 0,
    OneSDKItemType_TAOBAO2      = 1,
    OneSDKItemType_TMALL1       = 2,
    OneSDKItemType_TMALL2       = 3,
};


/*!
 @brief PromoType可选值:shop、auction
 !*/
typedef NS_ENUM(NSInteger, OneSDKPromoType)
{
    OneSDKPromoType_SNSHOP      = 0,
    OneSDKPromoType_IDAUCTION   = 1
};


@end


#pragma mark - 线上宝贝
//==============release taobao item===============//
#define RELEASEURL_TB1          @""
#define RELEASETAOKEURL_TB1     @"https://taoquan.taobao.com/coupon/unify_apply.htm?sellerId=2165762428&activityId=5698d91c0b474d9caf88279009bda4f3"
#define RELEASEITEMID_TB1       @"520628515496"        //23082328  AAHPt-dcABxGVVui-VRMv5Gm
//#define RELEASEITEMID_TB1       @"AAGcIOpwABpJi95ZrWi_VOWw"       //23015524
#define RELEASEREALITEMID_TB1   @"575688730394"   //531567410777    520628515496
#define RELEASESHOPID_TB1       @"113669907"
#define RELEASEITEMTYPE_TB1     @"1"
#define RELEASESKUID_TB1        @"74133269398"
#define PRERELEASEURL_TB1       @"http://h5.wapa.taobao.com/cm/snap/index.html?id=526936913648"

//专享价宝贝
#define RELEASEURL_TB2          @"http://s.click.taobao.com/t?e=m%3D2%26s%3D1jBWv7M6gTUcQipKwQzePOeEDrYVVa64LKpWJ%2Bin0XJRAdhuF14FMQTfn3Ee1bdjxq3IhSJN6GTIhnv1oNPKcIu1IsQeTOU265Sw8eKESWqqgdP%2BAKekAmlX8n%2F4fqv2WdvMW3csa5338r%2Bm48V%2FzcYOae24fhW0"
#define RELEASETAOKEURL_TB2     @"https://shop63626912.m.taobao.com/shop/shopIndex.htm?shop_id=63626912"
#define RELEASEITEMID_TB2       @"527599978512"         //23082328   21583871144  80 528959901119  2100  43954883729  8000
//#define RELEASEITEMID_TB2       @"AAEcIOpwABpJi95ZrWsQcHG0"       //23015524
#define RELEASEREALITEMID_TB2   @"534222466320"        //535869729756  188.2    527599978512 70.5
#define RELEASESHOPID_TB2       @"113669907"
#define RELEASEITEMTYPE_TB2     @"1"
#define RELEASESKUID_TB2        nil
//#define PRERELEASEURL_TB2       @"http://h5.wapa.taobao.com/cm/snap/index.html?id=41576306115"
#define PRERELEASEURL_TB2       @"http://h5.wapa.taobao.com/item.htm?spm=a1z10.3-c.w4002-11208743438.74.JJkYox&id=520776050719"

//商超宝贝 线上环境修改预发环境
#define RELEASEURL_TM1          @"http://h5.waptest.taobao.com/src/bcjsbridge.html"
#define RELEASETAOKEURL_TM1     @"https://h5.waptest.taobao.com/src/aplus2ut.html"
#define RELEASEITEMID_TM1       @"AAHtt-dcABxGVVui-V7fUxWP"         //23082328
//#define RELEASEITEMID_TM1       @"AAGvIOpwABpJi95ZrWuaihGD"       //23015524
#define RELEASEREALITEMID_TM1   @"43295928842"
#define RELEASESHOPID_TM1       @"113669907"
#define RELEASEITEMTYPE_TM1     @"2"
#define RELEASESKUID_TM1        nil
#define PRERELEASEURL_TM1       @"https://chaoshi.detail.wapa.tmall.com/item.htm?spm=0.0.0.0.SEsTTK&userBucket=17&id=13921456618"


//天猫商品
#define RELEASEURL_TM2          @"https://h5.m.taobao.com/src/bcjsbridge.html?spm=0.0.0.0.OiHhBh"
#define RELEASETAOKEURL_TM2     @"https://h5.m.taobao.com/awp/core/detail.htm?id=22429824161"
#define RELEASEITEMID_TM2       @"AAEPt-dcABxGVVui-VjacHDE"        //23082328
//#define RELEASEITEMID_TM2       @"AAGeIOpwABpJi95ZrWeGv5DW"       //23015524
#define RELEASEREALITEMID_TM2   @"22429824161" //42199112392

#define RELEASESHOPID_TM2       @"58498367"
#define RELEASEITEMTYPE_TM2     @"2"
#define RELEASESKUID_TM2        nil
#define PRERELEASEURL_TM2       @"http://detail.wapa.tmall.com/item.htm?id=22429824161"
//===============================================//


//==============release Taoke===============//
#define RELEASETAOKEPID         @"mm_100713040_22792955_75330474"
#define RELEASETAOKEUNIONID     nil
//==========================================//


//===========release 优惠券,电子凭证===========//
#define RELEASESELLNICK         @"c测试账号0515"
#define RELEASEITID             @"AAHiIOpwABpJi95ZrWtQ9RKU"
#define RELEASEORDERID          @"931159680463903"
//==========================================//
