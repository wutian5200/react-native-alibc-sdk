

#import "TaobaoOAuthViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
//#import <WeexSDK/WeexSDK.h>
//#import "AppDefine.h"
//#import "BQProgressHUD.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <AlibabaAuthSDK/ALBBSession.h>
#import <AlibabaAuthSDK/ALBBSDK.h>
//#import "WeexConfig.h"
//#import "UIViewController+ShowLoading.h"

#define iPhoneX_Top_Height (([UIScreen mainScreen].bounds.size.height == 812 || [UIScreen mainScreen].bounds.size.height == 896)?88:64)

@interface TaobaoOAuthViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) JSContext *jsContext;

//是否跳转的是二合一优惠券领取页面
@property (nonatomic, assign) BOOL isCouponPage;


@end

@implementation TaobaoOAuthViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
        
        _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, iPhoneX_Top_Height, self.view.frame.size.width, self.view.frame.size.height - iPhoneX_Top_Height)];
        [self.view addSubview:_myWebView];
        _myWebView.delegate = self;
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.jsContext = [[JSContext alloc] init];
    
//    self.title = @"购物车";
    [self setUpUI];
}

- (void)setUpUI
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage imageNamed:@"shopCarBack"] forState:UIControlStateNormal];
    [backBtn sizeToFit];
    UIBarButtonItem *wifiBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = wifiBtnItem;
}

- (void)backBtnAction
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSDictionary * authInfo = @{};
        ALBBUser *user = [[ALBBSession sharedInstance] getUser];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:@"false" forKey:@"status"];
        [dic setObject:@"27863370" forKey:@"bcAppkey"];
        [dic setObject:user.openId forKey:@"bcOpenId"];
        [dic setObject:@"false" forKey:@"isBcAuth"];
        [dic setObject:authInfo forKey:@"authInfo"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getAuthInfoDidSuccess" object:dic];
    }];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *url = [request.URL absoluteString];
    
    if ([url rangeOfString:@"baseapi/ali/aliTopCallbackForGetAuthCode"].location != NSNotFound) {
        
        NSURL *URL = [NSURL URLWithString:url];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:URL];
        [request setHTTPMethod:@"GET"];
        [request willChangeValueForKey:@"timeoutInterval"];
        [request setTimeoutInterval:10];
        [request didChangeValueForKey:@"timeoutInterval"];
        [request setValue:@"XDEBUG_SESSION=PHPSTORM; " forHTTPHeaderField:@"Cookie"];
        
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = nil;
        NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:recervedData options:kNilOptions error:nil];
        if ([dict[@"code"] isEqualToNumber:@100]) {
            NSDictionary * authInfo = dict[@"data"];
            ALBBUser *user = [[ALBBSession sharedInstance] getUser];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:@"true" forKey:@"status"];
//            [dic setObject:[WeexConfig shared].bcAppKey forKey:@"bcAppkey"];
            [dic setObject:@"27863370" forKey:@"bcAppkey"];
            [dic setObject:user.openId forKey:@"bcOpenId"];
            [dic setObject:@"false" forKey:@"isBcAuth"];
            [dic setObject:authInfo forKey:@"authInfo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getAuthInfoDidSuccess" object:dic];
        } else {
            NSDictionary * authInfo = dict[@"data"];
            ALBBUser *user = [[ALBBSession sharedInstance] getUser];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:@"false" forKey:@"status"];
            [dic setObject:@"27863370" forKey:@"bcAppkey"];
            [dic setObject:user.openId forKey:@"bcOpenId"];
            [dic setObject:@"false" forKey:@"isBcAuth"];
            [dic setObject:authInfo forKey:@"authInfo"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getAuthInfoDidSuccess" object:dic];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        //            NSDictionary *params = [self getRequestParams:request];
        //            NSString *d = request.URL.scheme;
        //            if ([request.URL.scheme isEqualToString:@"callback"]) {
        //                NSString *dictStr = params[@"data"];
        //                NSDictionary *dict = [self JSONValue:dictStr];
        //
        //            }
        
        return NO;
    }
    
    return YES;
}

//开始发送请求（加载数据）时调用这个方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    //判断是否跳转的是二合一优惠券领取页面
    NSString *currentURL= webView.request.URL.absoluteString;
    if ([currentURL rangeOfString:@"https://oauth.taobao.com/authorize?response_type=code"].location != NSNotFound){
        self.isCouponPage = YES;
    }
}

//请求完毕（加载数据完毕）时调用这个方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//
////        NSString *js = @"function add(a,b) {return a+b}";
////        [self.jsContext evaluateScript:js];
////        JSValue *n = [self.jsContext[@"add"] callWithArguments:@[@2, @3]];
////        [BQProgressHUD showToast:[NSString stringWithFormat:@"=======%d",[n toInt32]] hideAfterDelay:2];
//
//        NSString *currentURL= webView.request.URL.absoluteString;
//
//        NSString *contentStr = [self.myWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
//
//        NSLog(@"%@%@",currentURL,contentStr);
//
//    });
    
    
    NSMutableString * stringM = [NSMutableString string];
    
    [stringM appendString:@"document.querySelector(\"#content .authorize\").style.marginTop='-2px';"];
    
    [stringM appendString:@"document.querySelector(\"#content .authorize .login-form div.user\").style.padding='15% 10%';"];
    
    [stringM appendString:@"document.querySelector(\"#content .authorize .login-form div.login-option\").style.opacity=0;"];
    
    [stringM appendString:@"document.querySelector(\"#J_Submit\").style.height='46px';"];
    
    [stringM appendString:@"document.querySelector(\"#J_Submit\").style.borderRadius='23px';"];
    
    [stringM appendString:@"document.querySelectorAll(\"#content .authorize .login-form div.user .img img\")[0].style.borderRadius='5px';"];
    
    [stringM appendString:@"document.querySelectorAll(\"#content .authorize .login-form div.user .img img\")[1].style.borderRadius='5px';"];
    
    [stringM appendString:@"document.querySelectorAll(\"#content .authorize .login-form div.user .img .name\")[0].style.marginTop='5px';"];
    
    [stringM appendString:@"document.querySelectorAll(\"#content .authorize .login-form div.user .img .name\")[1].style.marginTop='5px';"];
    
    [stringM appendString:@"document.querySelector(\"#J_Submit\").style.marginTop='10px';"];
    
    
    [self.myWebView stringByEvaluatingJavaScriptFromString:stringM];
    
}


////添加Params接收转化方法
//- (NSDictionary *)getRequestParams:(NSURLRequest *)request {
//    return [self parametersWithQuery:request.URL.query withSeparator:@"=" delimiter:@"&"];
//
//}
//
//- (NSDictionary *)parametersWithQuery:(NSString *)query withSeparator:(NSString *)separator
//                                delimiter:(NSString *)delimiter {
//    NSArray *parameterPairs = [query componentsSeparatedByString:delimiter];
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithCapacity:[parameterPairs count]];
//    for (NSString *currentPair in parameterPairs) {
//        NSRange range = [currentPair rangeOfString:separator];
//        if (range.location == NSNotFound)
//            continue;
//        NSString *key = [currentPair substringToIndex:range.location];
//        NSString *value = [currentPair substringFromIndex:range.location + 1];
//        [parameters setObject:[value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:key];
//    }
//    return parameters;
//}
//
//- (id)JSONValue:(NSString *)dictStr {
//    id obj = [NSJSONSerialization JSONObjectWithData:[dictStr dataUsingEncoding:NSUTF8StringEncoding]
//                                             options:NSJSONReadingMutableContainers
//                                               error:nil];
//    return obj;
//}




//请求错误时调用这个方法
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
