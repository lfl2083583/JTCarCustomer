//
//  JTTradeWebViewController.m
//  JTSocial
//
//  Created by apple on 2017/10/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTTradeWebViewController.h"
#import "ZTSimpleWebView.h"

@interface JTTradeWebViewController () <WKScriptMessageHandler>

@property (strong, nonatomic) ZTSimpleWebView *webview;

@end

@implementation JTTradeWebViewController

- (void)changeURLAddress:(NSString *)urlString
{
    self.webview.urlString = urlString;
}

- (void)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"iosTrade"]) {
        if ([message.body isKindOfClass:[NSDictionary class]]) {
            NSInteger tradeType = [[message.body objectForKey:@"type"] integerValue];
            if (tradeType == 1) {
                [JTUserInfo shareUserInfo].userBalance += [message.body[@"value"] doubleValue];
                [[JTUserInfo shareUserInfo] save];
                [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateBalanceNotification object:nil];
            }
        }
    }
    else if ([message.name isEqualToString:@"iosCloseWeb"]) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = @"充值";
    self.view.backgroundColor = WhiteColor;
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    }
    [self.view addSubview:self.webview];
}

- (ZTSimpleWebView *)webview
{
    if (!_webview) {
        _webview = [[ZTSimpleWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) urlString:[NSString stringWithFormat:@"https://h5.6che.vip/pay/%@", [JTUserInfo shareUserInfo].userID]];
        _webview.messageHander = self;
    }
    return _webview;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
