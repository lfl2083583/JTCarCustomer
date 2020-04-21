//
//  JTDataLogicSessionListViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTDataLogicSessionListViewController.h"
#import "UIBarButtonItem+WZLBadge.h"
#import "MMDrawerController.h"

@interface JTDataLogicSessionListViewController () <NIMConversationManagerDelegate>
{
    BOOL isDisableReload;
}
@end

@implementation JTDataLogicSessionListViewController

- (void)reloadUI:(BOOL)isReloadTableView
{
    if (isReloadTableView && !self.tableview.hidden) {
        [self.tableview reloadData];
    }
    UITabBarController *tabBarController = (UITabBarController *)[(MMDrawerController *)[UIApplication sharedApplication].keyWindow.rootViewController centerViewController];
    UIViewController *viewController = [(UINavigationController *)[tabBarController.viewControllers objectAtIndex:0] topViewController];
    NIMRecentSession *recent = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:[NIMSession session:kJTSystemID type:NIMSessionTypeP2P]];
    if (recent && recent.unreadCount > 0) {
        [viewController.navigationItem.rightBarButtonItem showBadgeWithStyle:WBadgeStyleNumber value:recent.unreadCount animationType:WBadgeAnimTypeNone];
    }
    else
    {
        [viewController.navigationItem.rightBarButtonItem showBadgeWithStyle:WBadgeStyleNumber value:0 animationType:WBadgeAnimTypeNone];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    isDisableReload = NO;
    [self reloadUI:!isDisableReload];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    isDisableReload = YES;
    [super viewDidDisappear:animated];
}

- (void)loadSessionList
{
    self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    if (!self.recentSessions.count) {
        self.recentSessions = [NSMutableArray array];
    }
    [[NIMSDK sharedSDK].conversationManager addDelegate:self];
    [self reloadUI:YES];
}

- (void)setRecentSessions:(NSMutableArray *)recentSessions
{
    if (_recentSessions) {
        [_recentSessions removeAllObjects];
    }
    else
    {
        _recentSessions = [NSMutableArray array];
    }
    
    if (recentSessions.count > 0) {
        NSMutableArray *onTempArr = [NSMutableArray array];
        for (NIMRecentSession *recentSession in recentSessions) {
            if (![recentSession.session.sessionId isEqualToString:kJTSystemID] && ![recentSession.session.sessionId isEqualToString:kJTCallBonusID]) {
                if (![[JTUserInfo shareUserInfo].sessionTops containsObject:recentSession.session.sessionId]) {
                    [_recentSessions addObject:recentSession];
                }
                else
                {
                    [onTempArr addObject:recentSession];
                }
            }
        }
        if (onTempArr.count > 0) {
            [_recentSessions insertObjects:onTempArr atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, onTempArr.count)]];
        }
    }
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].conversationManager removeDelegate:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTUserInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamMembersUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTUpdateDraftNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTUpdateSessionTopNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTUpdateNotifyForNewMsgNotification object:nil];
}

#pragma mark - NIMConversationManagerDelegate
- (void)didAddRecentSession:(NIMRecentSession *)recentSession
           totalUnreadCount:(NSInteger)totalUnreadCount
{
    self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    [self reloadUI:!isDisableReload];
}

- (void)didUpdateRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    [self reloadUI:!isDisableReload];
}

- (void)didRemoveRecentSession:(NIMRecentSession *)recentSession
              totalUnreadCount:(NSInteger)totalUnreadCount
{
    //如果删除本地会话后就不允许漫游当前会话，则需要进行一次删除服务器会话的操作
    [[NIMSDK sharedSDK].conversationManager deleteRemoteSessions:@[recentSession.session]
                                                      completion:^(NSError * _Nullable error) {
                                                      }];
    NSInteger index = [self findInsertRecentPlace:recentSession];
    if (index < self.recentSessions.count) {
        [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)messagesDeletedInSession:(NIMSession *)session
{
    self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    [self reloadUI:!isDisableReload];
}

- (void)allMessagesDeleted
{
    self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    [self reloadUI:!isDisableReload];
}

- (void)sort
{
    [self.recentSessions sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NIMRecentSession *item1 = obj1;
        NIMRecentSession *item2 = obj2;
        if (item1.lastMessage.timestamp < item2.lastMessage.timestamp) {
            return NSOrderedDescending;
        }
        if (item1.lastMessage.timestamp > item2.lastMessage.timestamp) {
            return NSOrderedAscending;
        }
        return NSOrderedSame;
    }];
}

- (NSInteger)findInsertRecentPlace:(NIMRecentSession *)recentSession {
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if (item.lastMessage.timestamp <= recentSession.lastMessage.timestamp) {
            *stop = YES;
            find  = YES;
            matchIdx = idx;
        }
    }];
    if (find) {
        return matchIdx;
    } else {
        return self.recentSessions.count;
    }
}

- (NSInteger)findInsertSessionPlace:(NIMSession *)session {
    __block NSUInteger matchIdx = 0;
    __block BOOL find = NO;
    [self.recentSessions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NIMRecentSession *item = obj;
        if ([item.session.sessionId isEqualToString:session.sessionId]) {
            *stop = YES;
            find  = YES;
            matchIdx = idx;
        }
    }];
    if (find) {
        return matchIdx;
    } else {
        return self.recentSessions.count;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadSessionList];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChangeNotification:) name:kLoginStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTUserInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamMembersUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDraftNotification:) name:kJTUpdateDraftNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTopNotification:) name:kJTUpdateSessionTopNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNotifyForNewMsgNotification:) name:kJTUpdateNotifyForNewMsgNotification object:nil];
}

- (void)loginStatusChangeNotification:(NSNotification *)notification
{
    if ([JTUserInfo shareUserInfo].isLogin) {
        self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
        [self reloadUI:!isDisableReload];
    }
    else
    {
        [self.recentSessions removeAllObjects];
        [self reloadUI:!isDisableReload];
    }
}

- (void)updateTableViewNotification:(NSNotification *)notification
{
    [self reloadUI:!isDisableReload];
}

- (void)updateDraftNotification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NIMSession class]]) {
        NSInteger index = [self findInsertSessionPlace:notification.object];
        if (index < self.recentSessions.count) {
            [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)updateTopNotification:(NSNotification *)notification
{
    self.recentSessions = [[NIMSDK sharedSDK].conversationManager.allRecentSessions mutableCopy];
    [self reloadUI:!isDisableReload];
}

- (void)updateNotifyForNewMsgNotification:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NIMSession class]]) {
        NSInteger index = [self findInsertSessionPlace:notification.object];
        if (index < self.recentSessions.count) {
            [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
