//
//  JTMainViewController.m
//  JTSocial
//
//  Created by apple on 2017/6/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTMainViewController.h"
#import "JTBaseNavigationController.h"
#import "JTSocialContainerViewController.h"
#import "JTActivityViewController.h"
#import "JTStoreViewController.h"
#import "JTCarLifeViewController.h"

@interface JTMainViewController () <NIMConversationManagerDelegate>

@end

@implementation JTMainViewController

- (void)dealloc
{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initSubview];
    [self calculatingSessionUnreadCount];
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
}

/**
 加载子视图
 */
- (void)initSubview
{
//    [JTSocialStautsUtil sharedCenter].isAdoptReview
    self.viewControllers = @[[self createTabbarSubViewController:[[JTSocialContainerViewController alloc] init] itemTitle:@"消息" itemImageString:@"tab_message_normal" itemSelectedImageString:@"tab_message_selected"],
                             [self createTabbarSubViewController:[[JTActivityViewController alloc] init] itemTitle:@"活动" itemImageString:@"tab_activity_normal" itemSelectedImageString:@"tab_activity_selected"],
                             [self createTabbarSubViewController:[[JTStoreViewController alloc] init] itemTitle:@"门店" itemImageString:@"tab_store_normal" itemSelectedImageString:@"tab_store_selected"],
                             [self createTabbarSubViewController:[[JTCarLifeViewController alloc] init] itemTitle:@"车生活" itemImageString:@"tab_car_normal" itemSelectedImageString:@"tab_car_selected"]];
}

#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount
{
    [self calculatingSessionUnreadCount];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    [self calculatingSessionUnreadCount];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    [self calculatingSessionUnreadCount];
}

- (void)messagesDeletedInSession:(NIMSession *)session
{
    [self calculatingSessionUnreadCount];
}

- (void)allMessagesDeleted
{
    [self calculatingSessionUnreadCount];
}

/**
 计算会话未读消息长度
 */
- (void)calculatingSessionUnreadCount
{
    NSInteger sessionUnreadCount = 0;
    for (NIMRecentSession *recentSession in [NIMSDK sharedSDK].conversationManager.allRecentSessions) {
        if (![recentSession.session.sessionId isEqualToString:kJTCallBonusID]) {
            if (recentSession.session.sessionType == NIMSessionTypeTeam && ([[NIMSDK sharedSDK].teamManager notifyStateForNewMsg:recentSession.session.sessionId] == NIMTeamNotifyStateAll))
            {
                sessionUnreadCount += recentSession.unreadCount;
            }
            else if (recentSession.session.sessionType == NIMSessionTypeP2P && [[NIMSDK sharedSDK].userManager notifyForNewMsg:recentSession.session.sessionId])
            {
                sessionUnreadCount += recentSession.unreadCount;
            }
        }
    }
    if (sessionUnreadCount > 0) {
        NSString *value = (sessionUnreadCount > 99)?@"99+":[NSString stringWithFormat:@"%ld", (long)sessionUnreadCount];
        [[self.viewControllers objectAtIndex:0].tabBarItem setBadgeValue:value];
    }
    else
    {
        [[self.viewControllers objectAtIndex:0].tabBarItem setBadgeValue:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIViewController *)createTabbarSubViewController:(UIViewController *)viewController itemTitle:(NSString *)itemTitle itemImageString:(NSString *)itemImageString itemSelectedImageString:(NSString *)itemSelectedImageString
{
    JTBaseNavigationController *navigationController = [[JTBaseNavigationController alloc] initWithRootViewController:viewController];
    navigationController.tabBarItem = [[UITabBarItem alloc] initWithTitle:itemTitle
                                                                    image:[[UIImage imageNamed:itemImageString] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                            selectedImage:[[UIImage imageNamed:itemSelectedImageString] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    return navigationController;
}

@end
