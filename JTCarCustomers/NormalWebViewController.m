//
//  NormalWebViewController.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/11.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "NormalWebViewController.h"
#import "ZTSimpleWebView.h"

@interface NormalWebViewController () <WKScriptMessageHandler>

@property (strong, nonatomic) ZTSimpleWebView *webview;

@end

@implementation NormalWebViewController

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
//    if ([message.name isEqualToString:@"iosDownApp"]) {
//        if ([message.body isKindOfClass:[NSDictionary class]]) {
//            JTSocialThirdUrlObject *object = [[JTSocialThirdUrlObject alloc] initWithGameID:message.body[@"game_id"] shareIcon:@"" shareTitle:@"" shareContent:@"" ext:@""];
//            NSString *urlstring = [NSString stringWithFormat:@"%@://%@?%@=%@", message.body[@"app_key"], JTPlatformOpenGame, kJTSocialPlatformMessage, [[object mj_JSONString] base64EncodedString]];
//            if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstring]]) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message.body[@"iosurl"]]];
//            }
//        }
//    }
}

- (instancetype)initWithNavTitle:(NSString *)navTitle urlString:(NSString *)urlString
{
    return [self initWithNavTitle:navTitle urlString:urlString callback:nil];
}

- (instancetype)initWithNavTitle:(NSString *)navTitle urlString:(NSString *)urlString callback:(void (^)(id))callback
{
    self = [super init];
    if (self) {
        self.navTitle = navTitle;
        self.urlString = urlString;
        if (callback) {
            self.callback = callback;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.navTitle && ![self.navTitle isBlankString])
    {
        self.navigationItem.title = self.navTitle;
    }
    if (self.urlString && ![self.urlString isBlankString])
    {
        _webview = [[ZTSimpleWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) urlString:self.urlString];
        _webview.messageHander = self;
        [self.view addSubview:_webview];
    }
    if (self.navigationController.viewControllers.count == 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)];
    }
    [self.view setBackgroundColor:WhiteColor];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
