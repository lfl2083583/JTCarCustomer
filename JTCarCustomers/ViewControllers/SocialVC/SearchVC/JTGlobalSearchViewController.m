//
//  JTGlobalSearchViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIImage+Extension.h"
#import "JTMailListModel.h"
#import "JTUserTableViewCell.h"
#import "JTTeamTableViewCell.h"

#import "JTUserSimpleTableViewCell.h"
#import "JTGlobalSearchLabelTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTGlobalSearchMessageTableViewCell.h"

#import "JTGlobalSearchViewController.h"
#import "JTCategoriesSearchViewController.h"
#import "JTMessagesSearchResultViewController.h"

@interface JTGlobalSearchViewController () <UITableViewDataSource, UISearchBarDelegate, JTGlobalSearchLabelTableViewCellDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *tipLB;
@property (nonatomic, strong) NIMMessageSearchOption *option;

@property (nonatomic, strong) NSArray *searchLabels;
@property (nonatomic, strong) NSMutableArray *allFriends;
@property (nonatomic, strong) NSMutableArray *allTeams;
@property (nonatomic, strong) NSMutableArray *allMessages;

@property (nonatomic, strong) NSMutableArray *friendsResult;
@property (nonatomic, strong) NSMutableArray *teamsResult;
@property (nonatomic, strong) NSMutableArray *messagesResult;

@property (nonatomic, assign) BOOL isSearching;

@end

@implementation JTGlobalSearchViewController

- (void)dealloc {
    CCLOG(@"JTGlobalSearchViewController销毁了");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self.view addSubview:self.searchBar];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:0 sectionFooterHeight:0];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.dataSource = self;
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableview registerClass:[JTGlobalSearchLabelTableViewCell class] forCellReuseIdentifier:globalSearchLabelIdentifier];
    [self.tableview registerClass:[JTUserSimpleTableViewCell class] forCellReuseIdentifier:userSimpleCellIdentifier];
    [self.tableview registerClass:[JTTeamTableViewCell class] forCellReuseIdentifier:teamCellIndentifer];
    [self.tableview registerClass:[JTGlobalSearchMessageTableViewCell class] forCellReuseIdentifier:globalSearchMessageIdentifier];
    [self.view addSubview:self.tipLB];
    
}

- (void)initDatas {
    self.searchLabels = @[@"好友", @"群聊", @"聊天记录", @"活动"];
    
    for (NSArray *array in [JTMailListModel sharedCenter].friendMembers) {
        for (NIMUser *user in array) {
            NSString *username = [JTUserInfoHandle showNick:user member:nil]?[JTUserInfoHandle showNick:user member:nil]:@"";
            [self.allFriends addObject:@{@"userName": username, @"user": user}];
        }
    }
    
    for (NIMTeam *team in [JTMailListModel sharedCenter].teamList) {
        [self.allTeams addObject:@{@"teamName": team.teamName, @"team": team}];
    }
}

- (void)handleSearch {
    __weak typeof(self)weakSelf = self;
    [self.friendsResult removeAllObjects];
    [self.teamsResult removeAllObjects];
    [self.messagesResult removeAllObjects];
    [self.allMessages removeAllObjects];
    
    NSPredicate *predicateFriends = [NSPredicate predicateWithFormat:@"userName CONTAINS[cd] %@", self.searchBar.text];
    [self.friendsResult addObjectsFromArray:[self.allFriends filteredArrayUsingPredicate:predicateFriends]];
    
    NSPredicate *predicateTeams = [NSPredicate predicateWithFormat:@"teamName CONTAINS[cd] %@", self.searchBar.text];
    [self.teamsResult addObjectsFromArray:[self.allTeams filteredArrayUsingPredicate:predicateTeams]];
    
    self.option.searchContent = self.searchBar.text;
    [[NIMSDK sharedSDK].conversationManager searchAllMessages:self.option result:^(NSError * _Nullable error, NSDictionary<NIMSession *,NSArray<NIMMessage *> *> * _Nullable messages) {
        
        for (NIMSession *session in messages.allKeys) {
            NSMutableDictionary *source = [NSMutableDictionary dictionary];
            NSArray *array = [messages objectForKey:session];
            [source setValue:session forKey:@"session"];
            if (session.sessionType == NIMSessionTypeTeam) {
                
                NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.sessionId];
                [source setValue:team.thumbAvatarUrl forKey:@"messageAvatar"];
                [source setValue:team.teamName forKey:@"messageTitle"];
            }
            else
            {
                NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:session.sessionId];
                [source setValue:user.userInfo.avatarUrl forKey:@"messageAvatar"];
                [source setValue:user.userInfo.nickName forKey:@"messageTitle"];
            }
            [weakSelf.messagesResult addObject:source];
            [weakSelf.allMessages addObject:array];
        }
        weakSelf.tipLB.hidden = weakSelf.friendsResult.count+weakSelf.teamsResult.count+weakSelf.messagesResult.count;
        [weakSelf.tableview reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isSearching) {
        JTGlobalSearchLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:globalSearchLabelIdentifier];
        cell.dataArray = self.searchLabels;
        cell.delegate = self;
        return cell;
    }
    else
    {
        switch (indexPath.section) {
            case 0:
            {
                if (indexPath.row == 0) {
                    return [self createNormalTableViewCell:@"好友" textFont:Font(14) leftImage:nil textColor:BlackLeverColor3 userInteractionEnabled:NO accessoryType:UITableViewCellAccessoryNone indexPath:indexPath];
                }
                else if (indexPath.row < 4)
                {
                    JTUserSimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userSimpleCellIdentifier];
                    NIMUser *user = self.friendsResult[indexPath.row-1][@"user"];
                    NSString *userName = self.friendsResult[indexPath.row-1][@"userName"];
                    [cell.avatar setAvatarByUrlString:[user.userInfo.avatarUrl avatarHandleWithSquare:40] defaultImage:DefaultSmallAvatar];
                    cell.nameLB.text = userName;
                    [cell.genderGradeImageView configGenderView:user.userInfo.gender grade:[JTUserTableViewCell caculateBirthWithBirthDate:user.userInfo.birth]];
                    cell.horizontalView.hidden = NO;
                    [Utility richTextLabel:cell.nameLB fontNumber:Font(18) andRange:[userName rangeOfString:self.searchBar.text] andColor:BlueLeverColor1];
                    return cell;
                }
                else
                {
                    return [self createNormalTableViewCell:@"查看更多好友" textFont:Font(14) leftImage:[UIImage imageNamed:@"search_icon"] textColor:BlueLeverColor1 userInteractionEnabled:YES accessoryType:UITableViewCellAccessoryDisclosureIndicator indexPath:indexPath];
                }
            }
                break;
            case 1:
            {
                if (indexPath.row == 0) {
                    return [self createNormalTableViewCell:@"群聊" textFont:Font(14) leftImage:nil textColor:BlackLeverColor3 userInteractionEnabled:NO accessoryType:UITableViewCellAccessoryNone indexPath:indexPath];
                }
                else if (indexPath.row < 4)
                {
                    JTTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamCellIndentifer];
                    NIMTeam *team = self.teamsResult[indexPath.row-1][@"team"];
                    [cell configTeamCellWithTeam:team];
                    [Utility richTextLabel:cell.topLabel fontNumber:Font(18) andRange:[team.teamName rangeOfString:self.searchBar.text] andColor:BlueLeverColor1];
                    return cell;
                }
                else
                {
                    return [self createNormalTableViewCell:@"查看更多群聊" textFont:Font(14) leftImage:[UIImage imageNamed:@"search_icon"] textColor:BlueLeverColor1 userInteractionEnabled:YES accessoryType:UITableViewCellAccessoryDisclosureIndicator indexPath:indexPath];
                }
            }
                break;
            case 2:
            {
                if (indexPath.row == 0) {
                    return [self createNormalTableViewCell:@"聊天记录" textFont:Font(14) leftImage:nil textColor:BlackLeverColor3 userInteractionEnabled:NO accessoryType:UITableViewCellAccessoryNone indexPath:indexPath];
                }
                else if (indexPath.row < 4)
                {
                    JTGlobalSearchMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:globalSearchMessageIdentifier];
                    NSDictionary *source = self.messagesResult[indexPath.row-1];
                    NSArray *messages = self.allMessages[indexPath.row-1];
                    [cell.avatarImageView setAvatarByUrlString:[source[@"messageAvatar"] avatarHandleWithSquare:50] defaultImage:DefaultSmallAvatar];
                    cell.nameLabel.text = source[@"messageTitle"];
                    NIMMessage *message = [messages firstObject];
                    cell.timeLabel.text = [Utility showTime:message.timestamp showDetail:NO];
                    if (messages.count == 1) {
                        
                        cell.messageLabel.text = message.text;
                        [Utility richTextLabel:cell.messageLabel fontNumber:Font(14) andRange:[message.text rangeOfString:self.searchBar.text] andColor:BlueLeverColor1];
                    }
                    else
                    {
                        NSString *content = [NSString stringWithFormat:@"%ld条相关消息",messages.count];
                        NSString *rangeStr = [NSString stringWithFormat:@"%ld",messages.count];
                        cell.messageLabel.text = content;
                        [Utility richTextLabel:cell.messageLabel fontNumber:Font(14) andRange:[content rangeOfString:rangeStr] andColor:BlueLeverColor1];
                    }
                    
                    return cell;
                }
                else
                {
                    return [self createNormalTableViewCell:@"查看更多聊天记录" textFont:Font(14) leftImage:[UIImage imageNamed:@"search_icon"] textColor:BlueLeverColor1 userInteractionEnabled:YES accessoryType:UITableViewCellAccessoryDisclosureIndicator indexPath:indexPath];
                }
            }
                break;
            default:
                return [self createNormalTableViewCell:@"" textFont:Font(14) leftImage:nil textColor:BlackLeverColor3 userInteractionEnabled:YES accessoryType:UITableViewCellAccessoryNone indexPath:indexPath];
                break;
        }
    }
    
}

- (UITableViewCell *)createNormalTableViewCell:(NSString *)textTitle textFont:(UIFont *)textFont leftImage:(UIImage *)leftImage textColor:(UIColor *)textColor userInteractionEnabled:(BOOL)userInteractionEnabled accessoryType:(UITableViewCellAccessoryType)accessoryType indexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *horizontalView = [[UIView alloc] initWithFrame:CGRectMake(0, 44-0.5, self.tableview.width, 0.5)];
        horizontalView.backgroundColor = BlackLeverColor2;
        horizontalView.tag = 10;
        [cell.contentView addSubview:horizontalView];
    }
    UIView *horizontalView = [cell viewWithTag:10];
    horizontalView.hidden = (indexPath.row == 0);
    cell.textLabel.font = textFont;
    cell.textLabel.textColor = textColor;
    cell.textLabel.text = textTitle;
    cell.userInteractionEnabled = userInteractionEnabled;
    cell.contentView.backgroundColor = WhiteColor;
    cell.accessoryType = accessoryType;
    cell.imageView.image = leftImage;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.isSearching) {
        return 1;
    }
    switch (section) {
        case 0:
        {
            if (self.friendsResult.count > 0 && self.friendsResult.count <= 3) {
                return self.friendsResult.count+1;
            }
            else if (self.friendsResult.count > 3)
            {
                return 5;
            }
            else
            {
                return 0;
            }
        }
            break;
        case 1:
        {
            if (self.teamsResult.count > 0 && self.teamsResult.count <= 3) {
                return self.teamsResult.count+1;
            }
            else if (self.teamsResult.count > 3)
            {
                return 5;
            }
            else
            {
                return 0;
            }
        }
            break;
        case 2:
        {
            if (self.messagesResult.count > 0 && self.messagesResult.count <= 3) {
                return self.messagesResult.count+1;
            }
            else if (self.messagesResult.count > 3)
            {
                return 5;
            }
            else
            {
                return 0;
            }
        }
            break;
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.isSearching?3:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    if (!_isSearching) {
        return [tableView fd_heightForCellWithIdentifier:globalSearchLabelIdentifier cacheByIndexPath:indexPath configuration:^(JTGlobalSearchLabelTableViewCell *cell) {
            cell.dataArray = weakSelf.searchLabels;
        }];
    }
    if (indexPath.row == 0) {
        return 30;
    }
    else if (indexPath.row == 4)
    {
        return 44;
    }
    else
    {
        return 70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!self.isSearching) {
        return;
    }
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row < 4) {
                NIMUser *user = self.friendsResult[indexPath.row-1][@"user"];
                [self startConversation:[NIMSession session:user.userId type:NIMSessionTypeP2P]];
            }
            else
            {
                [self.navigationController pushViewController:[[JTCategoriesSearchViewController alloc] initWithSearchType:indexPath.section originalSource:self.friendsResult searchKeyword:self.searchBar.text] animated:YES];
            }
        }
            break;
        case 1:
        {
            if (indexPath.row < 4) {
                NIMTeam *team = self.teamsResult[indexPath.row-1][@"team"];
                [self startConversation:[NIMSession session:team.teamId type:NIMSessionTypeTeam]];
            }
            else
            {
                [self.navigationController pushViewController:[[JTCategoriesSearchViewController alloc] initWithSearchType:indexPath.section originalSource:self.teamsResult searchKeyword:self.searchBar.text] animated:YES];
            }
        }
            break;
        case 2:
        {
            if (indexPath.row < 4) {
                NSArray *messages = self.allMessages[indexPath.row-1];
                [self.navigationController pushViewController:[[JTMessagesSearchResultViewController alloc] initWithMessages:messages searchKeyword:self.searchBar.text] animated:YES];
             
            }
            else
            {
                [self.navigationController pushViewController:[[JTCategoriesSearchViewController alloc] initWithSearchType:indexPath.section originalSource:self.messagesResult searchKeyword:self.searchBar.text messages:self.allMessages] animated:YES];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self handleSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar.text.length == 0) {
        self.isSearching = NO;
        self.tipLB.hidden = YES;
        [self.tableview reloadData];
    }
    else
    {
        self.isSearching = YES;
    }
}

#pragma mark - JTGlobalSearchLabelTableViewCellDelegate
- (void)globalSearchLabelTableViewCellLabelClick:(NSInteger)index {
    [self.navigationController pushViewController:[[JTCategoriesSearchViewController alloc] initWithSearchType:index] animated:YES];
}

- (void)startConversation:(NIMSession *)session {
    JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:sessionVC animated:YES];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, kStatusBarHeight, [UIScreen mainScreen].bounds.size.width, kTopBarHeight);
        _searchBar.showsCancelButton = YES;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.backgroundColor = WhiteColor;
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.searchResultsButtonSelected = YES;
    }
    return _searchBar;
}

- (NSMutableArray *)allFriends {
    if (!_allFriends) {
        _allFriends = [NSMutableArray array];
    }
    return _allFriends;
}

- (NSMutableArray *)allTeams {
    if (!_allTeams) {
        _allTeams = [NSMutableArray array];
    }
    return _allTeams;
}

- (NSMutableArray *)friendsResult {
    if (!_friendsResult) {
        _friendsResult = [NSMutableArray array];
    }
    return _friendsResult;
}

- (NSMutableArray *)teamsResult {
    if (!_teamsResult) {
        _teamsResult = [NSMutableArray array];
    }
    return _teamsResult;
}

- (NSMutableArray *)allMessages {
    if (!_allMessages) {
        _allMessages = [NSMutableArray array];
    }
    return _allMessages;
}

- (NIMMessageSearchOption *)option
{
    if (!_option) {
        _option = [[NIMMessageSearchOption alloc] init];
        _option.limit = 20;
        _option.order = NIMMessageSearchOrderDesc;
        _option.messageTypes = @[[NSNumber numberWithInteger:NIMMessageTypeText]];
    }
    return _option;
}

- (NSMutableArray *)messagesResult {
    if (!_messagesResult) {
        _messagesResult = [NSMutableArray array];
    }
    return _messagesResult;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"找不到结果~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}

@end
