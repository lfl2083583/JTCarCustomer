//
//  JTMailTableView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMailTableView.h"
#import "JTUserTableViewCell.h"
#import "JTTeamTableViewCell.h"

@implementation JTMailTableItem

@end

@interface JTMailTableView () <UITableViewDelegate, UITableViewDataSource, JTUserTableViewCellDelegate>

@end

@implementation JTMailTableView


- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {

        [self registerClass:[JTUserTableViewCell class] forCellReuseIdentifier:userTableViewIndentifier];
        [self registerClass:[JTTeamTableViewCell class] forCellReuseIdentifier:teamCellIndentifer];
        [self setup];
    }
    return self;
}

- (void)setup {
    self.dataSource = self;
    self.delegate = self;
    self.backgroundColor = BlackLeverColor1;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.tableFooterView = [[UIView alloc] init];
    self.sectionIndexColor = BlackLeverColor3;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setItem:(JTMailTableItem *)item
{
    _item = item;
    [self reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.item.mailType == JTMailTypeTeam)
    {
        JTTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamCellIndentifer];
        NSDictionary *teamSource = self.item.dataArray[indexPath.section];
        NIMTeam *team = [teamSource objectForKey:@"team"];
        NSTimeInterval activeTime = [[teamSource objectForKey:@"activeTime"] integerValue];
        [cell configTeamCellWithTeam:team];
        cell.bottomLabel.text = [NSString stringWithFormat:@"最近活跃:%@", [Utility showTime:activeTime showDetail:NO]];
        return cell;
    }
    else
    {
        JTUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userTableViewIndentifier];
        NIMUser *user;
        if (self.item.mailType == JTMailTypeFriends)
        {
            if (indexPath.row == 0) {
                static NSString *normalIndentifier = @"UITableViewCell";
                UITableViewCell *normalCell = [tableView dequeueReusableCellWithIdentifier:normalIndentifier];
                if (!normalCell) {
                    normalCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:normalIndentifier];
                    normalCell.textLabel.font = Font(14);
                    normalCell.textLabel.textColor = BlackLeverColor3;
                    normalCell.userInteractionEnabled = NO;
                }
                normalCell.textLabel.text = self.item.indexTitles[indexPath.section];
                return normalCell;
            }
            NSArray *array = self.item.dataArray[indexPath.section];
            user = array[indexPath.row-1];
        }
        else
        {
            user = self.item.dataArray[indexPath.section];
        }
        cell.delegate = self;
        cell.rightBtn.hidden = (self.item.mailType == JTMailTypeFans)?NO:YES;
        [cell configCellWithNIMUser:user];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.item.mailType == JTMailTypeFriends) {
        NSArray *array = self.item.dataArray[section];
        return array.count+1;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.item.dataArray?self.item.dataArray.count:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((self.item.mailType == JTMailTypeFriends) && indexPath.row == 0)?25:70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (self.item.mailType == JTMailTypeFriends)?0.01:0.01;
}


- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.item.indexTitles;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NIMSession *sesion;
    if (self.item.mailType == JTMailTypeFans || self.item.mailType == JTMailTypeFocus)
    {
        NIMUser *user = self.item.dataArray[indexPath.section];
        sesion = [NIMSession session:user.userId type:NIMSessionTypeP2P];
    }
    else if (self.item.mailType == JTMailTypeFriends)
    {
        NSArray *array = self.item.dataArray[indexPath.section];
        NIMUser *user = array[indexPath.row-1];
        sesion = [NIMSession session:user.userId type:NIMSessionTypeP2P];
    }
    else
    {
        NSDictionary *teamSource = self.item.dataArray[indexPath.section];
        NIMTeam *team = [teamSource objectForKey:@"team"];
        sesion = [NIMSession session:team.teamId type:NIMSessionTypeTeam];
    }
    
    if (_mailTableViewDelegate && [_mailTableViewDelegate respondsToSelector:@selector(mailTableView:didSelectAtSession:)]) {
        [_mailTableViewDelegate mailTableView:tableView didSelectAtSession:sesion];
    }
}

#pragma mark JTUserTableViewCellDelegate
- (void)followUserWithInfo:(NIMUser *)user {
    NSString *fid = [JTUserInfoHandle showUserId:user];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(FocusApi) parameters:@{@"fid" : fid, @"type" : @(YES)} success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        [[HUDTool shareHUDTool] showHint:@"关注成功" yOffset:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:kJTUserInfoUpdatedNotification object:nil];
    } failure:^(NSError *error) {
        
    }];
}


@end
