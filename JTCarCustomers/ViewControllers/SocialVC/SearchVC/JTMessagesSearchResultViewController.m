//
//  JTMessagesSearchResultViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGlobalSearchMessageTableViewCell.h"
#import "JTMessagesSearchResultViewController.h"
#import "JTSessionViewController.h"


@interface JTMessagesSearchResultViewController () <UITableViewDataSource>

@end

@implementation JTMessagesSearchResultViewController

- (void)dealloc {
    CCLOG(@"JTMessagesSearchResultViewController销毁了");
}

- (instancetype)initWithMessages:(NSArray *)messages searchKeyword:(NSString *)searchKeyword {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _messages = messages.reverseObjectEnumerator.allObjects;
        _searchKeyword = searchKeyword;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTalbeView:UITableViewStylePlain rowHeight:70];
    [self.tableview setDataSource:self];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview registerClass:[JTGlobalSearchMessageTableViewCell class] forCellReuseIdentifier:globalSearchMessageIdentifier];
    if (self.messages.count > 0) {
        NIMMessage *firstMessage = [self.messages firstObject];
        if (firstMessage.session.sessionType == NIMSessionTypeP2P) {
            self.navigationItem.title = [JTUserInfoHandle showNick:firstMessage.session.sessionId];
        }
        else
        {
            NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:firstMessage.session.sessionId];
            self.navigationItem.title =  team.teamName;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0)?30:70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messages.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.font = Font(14);
            cell.textLabel.textColor = BlackLeverColor3;
        }
        NSString *content = [NSString stringWithFormat:@"共%lu条相关的聊天记录", (unsigned long)self.messages.count];
        cell.textLabel.text = content;
        NSString *messageCount = [NSString stringWithFormat:@"%lu", (unsigned long)self.messages.count];
        [Utility richTextLabel:cell.textLabel fontNumber:Font(14) andRange:[content rangeOfString:messageCount] andColor:BlueLeverColor1];
        cell.userInteractionEnabled = NO;
        return cell;
    }
    else
    {
        JTGlobalSearchMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:globalSearchMessageIdentifier];
        NIMMessage *message = self.messages[indexPath.row-1];
        NSString *avatarUrl;
        NSString *name;
        if (message.session.sessionType == NIMSessionTypeTeam) {
            avatarUrl = [[[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId] avatarUrl];
            name = [[[NIMSDK sharedSDK].teamManager teamById:message.session.sessionId] teamName];
        } else {
            NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:message.session.sessionId];
            NIMUserInfo *info = user.userInfo;
            avatarUrl = info.avatarUrl;
            name = [JTUserInfoHandle showNick:message.session.sessionId];
        }
        [cell.avatarImageView setAvatarByUrlString:[avatarUrl avatarHandleWithSquare:50] defaultImage:DefaultSmallAvatar];
        cell.nameLabel.text = name;
        
        cell.timeLabel.text = [Utility showTime:message.timestamp showDetail:NO];
        cell.messageLabel.text = message.text;
        [Utility richTextLabel:cell.messageLabel fontNumber:Font(14) andRange:[message.text rangeOfString:self.searchKeyword] andColor:BlueLeverColor1];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NIMMessage *message = [self.messages objectAtIndex:indexPath.row-1];
    [self setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:[[JTSessionViewController alloc] initWithSession:message.session locationMessage:message] animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
