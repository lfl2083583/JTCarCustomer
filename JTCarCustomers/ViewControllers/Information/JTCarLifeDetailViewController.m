//
//  JTCarLifeDetailViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMessageMaker.h"
#import "JTShareTool.h"
#import "JTContactConfig.h"

#import "ZTSimpleWebView.h"

#import "JTBaseNavigationController.h"
#import "JTTeamSelectViewController.h"
#import "JTCarLifeDetailViewController.h"
#import "JTContracSelectViewController.h"

@interface JTCarLifeDetailViewController () <WKScriptMessageHandler, UIScrollViewDelegate>

@property (nonatomic, strong) ZTSimpleWebView *webView;

@end

@implementation JTCarLifeDetailViewController

- (instancetype)initWeburl:(NSString *)weburl navtitle:(NSString *)navtitle {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _weburl = weburl;
        _navtitle = navtitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navtitle;
    [self.view addSubview:self.webView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",message.body);
    if (![JTUserInfo shareUserInfo].isLogin) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://%@?", kJTCarCustomersScheme, JTPlatformLogin]]];
        return;
    }
    __weak typeof(self)weakSelf = self;
    NSDictionary *dictionary = message.body;
    NSString *method = [dictionary objectForKey:@"callback"];
    
    if ([message.name isEqualToString:@"getUserInfo"]) {
        
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(UserInfoApi) parameters:@{@"uid" : [JTUserInfo shareUserInfo].userID} success:^(id responseObject, ResponseState state) {
            [weakSelf handleJavaScriptMethod:method responseObject:responseObject];
        } failure:^(NSError *error) {
            
        }];
        
    }
    else if ([message.name isEqualToString:@"share"])
    {
        NSDictionary *progrem = [[dictionary objectForKey:@"progrem"] mj_JSONObject];
        NSString *shareType = [progrem objectForKey:@"obj_type"];
        NSString *shareID = [progrem objectForKey:@"obj_id"];
        
        [[JTShareTool instance] shareInfo:@{ShareUrl : progrem[@"shareUrl"], ShareTitle : progrem[@"title"], ShareDescribe : progrem[@"subTitle"], ShareThumbURL : progrem[@"img"]} result:^(NSError *error, JTSharePlatformType platformType) {
            NIMMessage *infomationMessage = [JTMessageMaker messageWithInformation:shareID h5Url:progrem[@"shareUrl"] coverUrl:progrem[@"img"] title:progrem[@"title"] content:progrem[@"subTitle"]];
            if (platformType == JTSharePlatformTypeFriend) {
                JTContactFriendConfig *config = [[JTContactFriendConfig alloc] init];
                config.contactSelectType = JTContactSelectTypeShareInfomation;
                config.needMutiSelected = NO;
                config.source = progrem;
                JTContracSelectViewController *userListVC = [[JTContracSelectViewController alloc] initWithConfig:config];
                userListVC.callBack = ^(NSArray *yunxinIDs, NSArray *userIDs, NSString *content) {
                    if ([[NIMSDK sharedSDK].chatManager sendMessage:infomationMessage toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil]) {
                        [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
                    }
                    if (content && [content isKindOfClass:[NSString class]] && content.length) {
                        NIMMessage *message = [JTMessageMaker messageWithText:content];
                        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[yunxinIDs firstObject] type:NIMSessionTypeP2P] error:nil];
                    }
                };
                JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:userListVC];
                [weakSelf presentViewController:navigationController animated:YES completion:nil];
            }
            else if (platformType == JTSharePlatformTypeTeam)
            {
                JTContactTeamMemberConfig *config = [[JTContactTeamMemberConfig alloc] init];
                config.contactSelectType = JTContactSelectTypeShareInfomation;
                config.needMutiSelected = NO;
                config.source = progrem;
                JTTeamSelectViewController *teamListVC = [[JTTeamSelectViewController alloc] initWithConfig:config];
                teamListVC.callBack = ^(NSArray *teamIDs, NSString *content) {
                    if ([[NIMSDK sharedSDK].chatManager sendMessage:infomationMessage toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil]) {
                        [[HUDTool shareHUDTool] showHint:@"发送成功" yOffset:0];
                    }
                    if (content && [content isKindOfClass:[NSString class]] && content.length) {
                        NIMMessage *message = [JTMessageMaker messageWithText:content];
                        [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:[NIMSession session:[teamIDs firstObject] type:NIMSessionTypeTeam] error:nil];
                    }
                };
                JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:teamListVC];
                [weakSelf presentViewController:navigationController animated:YES completion:nil];
            }
            else
            {
                if (!error) {
                    
                    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ShareStatisticsApi) parameters:@{@"type" : @(platformType+3), @"receiver" : @(0), @"obj_type" : shareType, @"obj_id" : shareID} success:^(id responseObject, ResponseState state) {
                        [[HUDTool shareHUDTool] showHint:@"分享成功！" yOffset:0];
                        [weakSelf handleJavaScriptMethod:method responseObject:responseObject];
                    } failure:^(NSError *error) {
                        
                    }];
                    
                }
            }
        }];
    }
    else if ([message.name isEqualToString:@"handlerHttp"])
    {
        NSString *url = [dictionary objectForKey:@"url"];
        NSDictionary *progrem = [[dictionary objectForKey:@"progrem"] mj_JSONObject];
        if (url && [url isKindOfClass:[NSString class]]) {
            
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(url) parameters:progrem success:^(id responseObject, ResponseState state) {
                [weakSelf handleJavaScriptMethod:method responseObject:responseObject];
            } failure:^(NSError *error) {
                
            }];
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

- (void)handleJavaScriptMethod:(NSString *)method responseObject:(id)responseObject {
    NSString *jsonStr = [responseObject mj_JSONString];
    NSString *jsStr = [NSString stringWithFormat:@"%@(%@)",method, jsonStr];
    [self.webView setJavaScriptString:jsStr success:^(id source) {}];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


- (ZTSimpleWebView *)webView {
    if (!_webView) {
        _webView = [[ZTSimpleWebView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) urlString:self.weburl];
        _webView.normalColor = WhiteColor;
        _webView.messageHander = self;
        WKWebView *wkwebView = _webView.webview;
        wkwebView.scrollView.delegate = self;
    }
    return _webView;
}

@end
