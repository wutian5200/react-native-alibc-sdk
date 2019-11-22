//
//  ALiTradeWantViewController.m
//  ALiSDKAPIDemo
//
//  Created by com.alibaba on 16/6/1.
//  Copyright © 2016年 alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALiTradeWebViewController.h"
#import <AlibcTradeSDK/AlibcTradeSDK.h>
#import <JavaScriptCore/JavaScriptCore.h>

//#import "ALiCartService.h"

@interface ALiTradeWebViewController()

@end

@implementation ALiTradeWebViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
        _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _webView.scrollView.scrollEnabled = YES;
        _webView.delegate = self;

        JSContext *context = [_webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];

        context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue)
          {
              context.exception = exceptionValue;
              NSLog(@"%@", @"exceptionValue");
          };
        context[@"myAction"] = ^(){
            NSLog(@"%@", @"ddddddddddddd");
            [self.navigationController popViewControllerAnimated:YES];
        };
//        context[@"passValue"] = ^{
//
//            NSArray *arg = [JSContext currentArguments];
//            for (id obj in arg) {
//                if([obj isEqualToString:@"exit"]){
//                    [self.navigationController popViewControllerAnimated:YES];
//                }
//                NSLog(@"%@", obj);
//            }
//        };

        
        
        [self.view addSubview:_webView];
    }
    
//    self.context = [self valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];//创建


    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"淘你喜欢";
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}
-(void)dealloc
{
    NSLog(@"dealloc  view");
    _webView =  nil;
}

-(void)setOpenUrl:(NSString *)openUrl {
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:openUrl]]];
}

-(UIWebView *)getWebView{
    return  _webView;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    if ([url rangeOfString:@"myExit://"].location != NSNotFound || [url rangeOfString:@"myexit://"].location != NSNotFound) {
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"拦截成功了");
        return NO;
    }
    return YES;
}
/**
 关闭WebView，返回到原生界面
 */
- (void)closeWebView{
    [self.navigationController popViewControllerAnimated:YES];

}

@end
