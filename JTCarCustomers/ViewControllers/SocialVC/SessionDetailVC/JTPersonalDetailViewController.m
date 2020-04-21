//
//  JTPersonalDetailViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTSwitchTableViewCell.h"
#import "JTMemberInfoTableViewCell.h"

#import "JTCardViewController.h"
#import "JTPersonalDetailViewController.h"
#import "JTMessageSearchViewController.h"

@interface JTPersonalDetailViewController () <UITableViewDataSource, JTSwitchTableViewCellDelegate>

@end

static NSString *normalIdentifier = @"UITableViewCell";

@implementation JTPersonalDetailViewController

- (instancetype)initWithSession:(NIMSession *)session {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
        _user = [[NIMSDK sharedSDK].userManager userInfo:session.sessionId];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComponent];
    [self.navigationItem setTitle:@"聊天详情"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview registerClass:[JTSwitchTableViewCell class] forCellReuseIdentifier:switchIdentifier];
    [self.tableview registerClass:[JTMemberInfoTableViewCell class] forCellReuseIdentifier:infoIdentifier];
    [self.tableview setDataSource:self];
}

- (void)setupComponent {
    JTWordItem *item1 = [self creatWordItem:@"个人详情" indentify:infoIdentifier];
    JTWordItem *item2 = [self creatWordItem:@"消息免打扰" indentify:switchIdentifier];
    JTWordItem *item3 = [self creatWordItem:@"置顶聊天" indentify:switchIdentifier];
    JTWordItem *item4 = [self creatWordItem:@"查找聊天记录" indentify:normalIdentifier];
    JTWordItem *item5 = [self creatWordItem:@"清空聊天记录" indentify:normalIdentifier];
    JTWordItem *item6 = [self creatWordItem:@"投诉" indentify:normalIdentifier];
    self.dataArray = [NSMutableArray arrayWithArray:@[@[item1], @[item2, item3, item4], @[item5, item6]]];
}

- (JTWordItem *)creatWordItem:(NSString *)title indentify:(NSString *)indentify {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = title;
    item.tagID = indentify;
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    NSString *indentify = item.tagID;
    if ([indentify isEqualToString:infoIdentifier])
    {
        JTMemberInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoIdentifier];
        [cell configMemberInfoCell:self.user];
        return cell;
    }
    else if ([indentify isEqualToString:switchIdentifier])
    {
        JTSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:switchIdentifier];
        cell.textLabel.text = item.title;
        cell.indexPath= indexPath;
        cell.delegate = self;
        if ([item.title isEqualToString:@"消息免打扰"])
        {
            cell.sw.on = ![[NIMSDK sharedSDK].userManager notifyForNewMsg:self.session.sessionId];
        }
        else if ([item.title isEqualToString:@"置顶聊天"])
        {
            cell.sw.on = [[JTUserInfo shareUserInfo].sessionTops containsObject:self.session.sessionId];
        }
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalIdentifier];
            cell.textLabel.font = Font(16);
            cell.textLabel.textColor = BlackLeverColor5;
            cell.detailTextLabel.font = Font(16);
            cell.detailTextLabel.textColor = BlackLeverColor3;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.text = item.title;
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.section == 0)?110:44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    if ([item.title isEqualToString:@"查找聊天记录"])
    {
        [self.navigationController pushViewController:[[JTMessageSearchViewController alloc] initWithSession:self.session] animated:YES];
    }
    else if ([item.title isEqualToString:@"清空聊天记录"])
    {
        __weak typeof(self) weakself = self;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要清空聊天记录吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NIMDeleteMessagesOption *option = [[NIMDeleteMessagesOption alloc] init];
            option.removeTable = YES;
            [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:weakself.session option:option];
            [[HUDTool shareHUDTool] showHint:@"已清空"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCleanSessionMessageNotification object:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else if ([item.title isEqualToString:@"投诉"])
    {
        [self complainPerson];
    }
    else if ([item.title isEqualToString:@"个人详情"])
    {
        NSString *userID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId]];
        [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:userID] animated:YES];
    }
}

#pragma mark JTSwitchTableViewCellDelegate
- (void)switchTableViewCell:(id)switchTableViewCell didChangeRowAtIndexPath:(NSIndexPath *)indexPath atValue:(BOOL)value {
    NSArray *array = self.dataArray[indexPath.section];
    JTWordItem *item = array[indexPath.row];
    if ([item.title isEqualToString:@"消息免打扰"])
    {
        __weak typeof(self) weakself = self;
        [[NIMSDK sharedSDK].userManager updateNotifyState:!value forUser:self.session.sessionId completion:^(NSError *error) {
            if (error) {
                [[HUDTool shareHUDTool] showHint:@"设置失败"];
                [[(JTSwitchTableViewCell *)[weakself.tableview cellForRowAtIndexPath:indexPath] sw] setOn:!value];
            }
            else
            {
                [[HUDTool shareHUDTool] showHint:@"设置成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kJTUpdateNotifyForNewMsgNotification object:nil];
            }
        }];
    }
    else if ([item.title isEqualToString:@"置顶聊天"])
    {
        if (value) {
            if (![[JTUserInfo shareUserInfo].sessionTops containsObject:self.session.sessionId]) {
                [[JTUserInfo shareUserInfo].sessionTops addObject:self.session.sessionId];
            }
        }
        else
        {
            if ([[JTUserInfo shareUserInfo].sessionTops containsObject:self.session.sessionId]) {
                [[JTUserInfo shareUserInfo].sessionTops removeObject:self.session.sessionId];
            }
        }
        [[JTUserInfo shareUserInfo] save];
        [[NSNotificationCenter defaultCenter] postNotificationName:kJTUpdateSessionTopNotification object:nil];
    }
}

- (void)complainPerson {
    NSArray *titles = @[@"政治谣言", @"内容违规", @"昵称、签名内容违规", @"广告", @"色情传播", @"非法传销"];
    NSString *userID = [JTUserInfoHandle showUserId:[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId]];
    UIAlertController *alertMore = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *title in titles) {
        [alertMore addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(UserComplaintsApi) parameters:@{@"object_type" : @"1", @"object" : userID, @"content" : action.title, @"type" : @"1"} success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] showHint:@"投诉成功，官方会在3个工作日核实处理" yOffset:0];
            } failure:^(NSError *error) {
                
            }];
        }]];
    }
    [alertMore addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertMore animated:YES completion:nil];
}

@end
