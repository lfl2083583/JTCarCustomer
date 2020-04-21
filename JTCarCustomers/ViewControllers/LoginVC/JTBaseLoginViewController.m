//
//  JTBaseLoginViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBaseLoginViewController.h"

@interface JTBaseLoginViewController ()

@end

@implementation JTBaseLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)socialLoginSeccess:(JTUserInfo *)userInfo
{
    [[[NIMSDK sharedSDK] loginManager] login:userInfo.userYXAccount token:userInfo.userYXToken completion:^(NSError * _Nullable error) {
        
        if (error == nil) {
            
            [userInfo setIsAppleAccount:([userInfo.userID isEqualToString:@"223245"] || [userInfo.userID isEqualToString:@"223339"])];
            [userInfo setIsLogin:YES];
            [userInfo save];
            [[HUDTool shareHUDTool] showHint:@"登录成功" yOffset:0];
            // 登录 状态改变通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kLoginStatusChangeNotification object:nil];
            // 同步关注关系
//            [JTUserRelationsTool syncServiceUserRelations];
//            // 同步聊天表情
//            [[NIMEmoticonTool shareExpressionTool] synchronizationData:nil failure:nil];
//            // 同步收藏表情
//            [[NIMEmoticonTool shareExpressionTool] synchronizationCollectionData:nil failure:nil];
//            // 回到主页
//            [appDelegate setupTabbarViewController];
//            // 版本检查
//            [appDelegate versionDetection];
        }
        else
        {
            [[HUDTool shareHUDTool] showHint:@"登录失败" yOffset:0];
        }
    }];
}

@end
