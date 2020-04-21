//
//  JTCarLifeViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTCicleLabel.h"
#import "ZTSimpleWebView.h"
#import "JTCarLifeViewController.h"
#import "JTCarLifeDetailViewController.h"

@interface JTCarLifeViewController () <WKScriptMessageHandler>

@property (nonatomic, strong) ZTSimpleWebView *webView;
@property (nonatomic, copy) NSString *webUrl;

@end

@implementation JTCarLifeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"车生活";
    
    ZTCicleLabel *label = [[ZTCicleLabel alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
    label.text = @"现在我们来测试一下这个自定义的按钮";
    label.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:label];
   
    
//    __weak typeof(self)weakSelf = self;
//    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GetCarLifeurlApi) parameters:nil success:^(id responseObject, ResponseState state) {
//        if (responseObject[@"url"] && [responseObject[@"url"] isKindOfClass:[NSString class]]) {
//            weakSelf.webUrl = responseObject[@"url"];
//            [weakSelf.view addSubview:weakSelf.webView];
//        }
//
//    } failure:^(NSError *error) {
//
//    }];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {
    
    if ([message.name isEqualToString:@"jump"])
    {
        NSString *navtitle = [message.body objectForKey:@"title"];
        NSString *weburl = [message.body objectForKey:@"url"];
        [self.navigationController pushViewController:[[JTCarLifeDetailViewController alloc] initWeburl:weburl navtitle:navtitle] animated:YES];
    }

    else if ([message.name isEqualToString:@"iosCloseWeb"]) {
        if (self.navigationController.viewControllers.count == 1) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (ZTSimpleWebView *)webView {
    if (!_webView) {
        _webView = [[ZTSimpleWebView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height-kBottomBarHeight) urlString:self.webUrl];
        _webView.normalColor = WhiteColor;
        _webView.messageHander = self;
    }
    return _webView;
}

@end
