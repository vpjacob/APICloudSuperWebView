//
//  ViewController.m
//  ProjectFirst
//
//  Created by kenny on 16/1/7.
//  Copyright (c) 2016年 APICloud. All rights reserved.
//

#import "ViewController.h"
#import "APIWindowContainer.h"
#import "APIManager.h"
#import "APIEvent.h"
#import "APIWebView.h"
#import "APIScriptMessage.h"
#import "APIModuleMethod.h"
#import "JJViewController.h"


@interface ViewController ()
<APIWebViewDelegate, APIModuleMethodDelegate, APIScriptMessageDelegate>

@property (nonatomic, strong) APIWindowContainer *windowContainer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[APIManager manager] setWebViewDelegate:self];
    [[APIManager manager] setModuleMethodDelegate:self];
    [[APIManager manager] setScriptMessageDelegate:self];
    
    [[APIEventCenter defaultCenter] addEventListener:self selector:@selector(handleEvent:) name:@"abc"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - 点击事件
- (IBAction)openSuperWebView:(UIButton *)button {
    button.highlighted = NO;
    
    // 这里的widget://表示widget的根目录路径
    NSString *url = @"widget://index.html";
    APIWindowContainer *windowContainer = [APIWindowContainer windowContainerWithUrl:url name:@"root" userInfo:nil];
    [windowContainer startLoad];
    [self.navigationController pushViewController:windowContainer animated:YES];
    self.windowContainer = windowContainer;
}

#pragma mark - 监听html页面发送的事件
- (void)handleEvent:(APIEvent *)event {
    NSString *msg = [NSString stringWithFormat:@"收到来自Html5的%@事件，传入的参数为:%@", event.name, event.userInfo];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - APIWebViewDelegate
- (BOOL)webView:(APIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    if ([url hasPrefix:@"http://www.taobao.com"]) {
        NSString *msg = @"不允许访问淘宝";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    } else if ([url hasPrefix:@"http://www.baidu.com"]) {
        return YES;
    }
    return YES;
}

#pragma mark - APIScriptMessageDelegate
- (void)webView:(APIWebView *)webView didReceiveScriptMessage:(APIScriptMessage *)scriptMessage {
    if ([scriptMessage.name isEqual:@"abc"]) {
        NSString *msg = [NSString stringWithFormat:@"收到来自Html5的操作请求，访问的名称标识为%@，传入的参数为:%@", scriptMessage.name, scriptMessage.userInfo];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        [webView sendResultWithCallback:scriptMessage.callback ret:@{@"result":@"value"} err:nil delete:YES];
    } else if ([scriptMessage.name isEqual:@"requestEvent"]) {
        [[APIEventCenter defaultCenter] sendEventWithName:@"fromNative" userInfo:@{@"value":@"哈哈哈，我是来自Native的事件"}];
    }else if ([scriptMessage.name isEqualToString:@"pushVC"]){
        JJViewController *vc = [JJViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - APIModuleMethodDelegate
- (BOOL)shouldInvokeModuleMethod:(APIModuleMethod *)moduleMethod {
    if ([moduleMethod.module isEqualToString:@"api"] && [moduleMethod.method isEqualToString:@"sms"]) {
        return NO;
    }
    return YES;
}

@end
