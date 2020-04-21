//
//  JTCategoriesSearchViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMailListModel.h"

#import "JTUserTableViewCell.h"
#import "JTTeamTableViewCell.h"
#import "JTUserSimpleTableViewCell.h"
#import "JTActivityJoinTableViewCell.h"
#import "JTGlobalSearchMessageTableViewCell.h"

#import "JTCategoriesSearchViewController.h"
#import "JTActivityDetailViewController.h"
#import "JTSessionViewController.h"
#import "JTMessagesSearchResultViewController.h"


@interface JTCategoriesSearchViewController () <UISearchBarDelegate, UITableViewDataSource, JTActivityJoinTableViewCellDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UILabel *tipLB;
@property (nonatomic, strong) NIMMessageSearchOption *option;
@property (nonatomic, strong) NSMutableArray *allFriends;
@property (nonatomic, strong) NSMutableArray *allTeams;
@property (nonatomic, strong) NSMutableArray *activities;
@property (nonatomic, strong) NSMutableArray *allMessages;
@property (nonatomic, assign) BOOL isSearching;

@end

@implementation JTCategoriesSearchViewController

- (void)dealloc {
    CCLOG(@"JTCategoriesSearchViewController销毁了");
}

- (instancetype)initWithSearchType:(JTSearchType)searchType originalSource:(id)originalSource searchKeyword:(NSString *)searchKeyword messages:(id)messages {
    self = [self initWithSearchType:searchType originalSource:originalSource searchKeyword:searchKeyword];
    if (self) {
        [self.allMessages addObjectsFromArray:messages];
    }
    return self;
}

- (instancetype)initWithSearchType:(JTSearchType)searchType originalSource:(id)originalSource searchKeyword:(NSString *)searchKeyword {
    self = [self initWithSearchType:searchType];
    if (self) {
        [self.dataArray addObjectsFromArray:originalSource];
        _searchKeyword = searchKeyword;
    }
    return self;
}

- (instancetype)initWithSearchType:(JTSearchType)searchType {
    self = [super init];
    if (self) {
        _searchType = searchType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    
    [self createTalbeView:(self.searchType == JTSearchTypeActivities)?UITableViewStyleGrouped:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:70];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone] ;
    [self.tableview setDataSource:self];
    [self setShowTableRefreshFooter:YES];
    [self setShowTableRefreshHeader:YES];
    [self.tableview setContentInset:UIEdgeInsetsMake(-60, 0, 0, 0)];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview registerClass:[JTUserSimpleTableViewCell class] forCellReuseIdentifier:userSimpleCellIdentifier];
    [self.tableview registerClass:[JTTeamTableViewCell class] forCellReuseIdentifier:teamCellIndentifer];
    [self.tableview registerClass:[JTGlobalSearchMessageTableViewCell class] forCellReuseIdentifier:globalSearchMessageIdentifier];
    [self.tableview registerClass:[JTActivityJoinTableViewCell class] forCellReuseIdentifier:activityJoinIdentifier];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tipLB];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDatas {
    NSString *placehold;
    switch (self.searchType) {
        case JTSearchTypeFriends:
        {
            placehold = @"搜索好友";
            for (NSArray *array in [JTMailListModel sharedCenter].friendMembers) {
                for (NIMUser *user in array) {
                    NSString *username = [JTUserInfoHandle showNick:user member:nil]?[JTUserInfoHandle showNick:user member:nil]:@"";
                    [self.allFriends addObject:@{@"userName": username, @"user": user}];
                }
            }
        }
            break;
        case JTSearchTypeTeams:
        {
            placehold = @"搜索群聊";
            for (NIMTeam *team in [JTMailListModel sharedCenter].teamList) {
                [self.allTeams addObject:@{@"teamName": team.teamName, @"team": team}];
            }
        }
            break;
        case JTSearchTypeMessages:
        {
            placehold = @"搜索聊天记录";
        }
            break;
        case JTSearchTypeActivities:
        {
            placehold = @"搜索活动";
        }
            break;
        default:
            break;
    }
    self.searchBar.placeholder = placehold;
    if (self.searchKeyword) {
        self.searchBar.text = self.searchKeyword;
    }
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    if (!self.searchBar.text.length) {
        [self.dataArray removeAllObjects];
        [self.activities removeAllObjects];
        [self.allMessages removeAllObjects];
        [super getListData:requestComplete];
        return;
    }
    switch (self.searchType) {
        case JTSearchTypeFriends:
        {
            [self.dataArray removeAllObjects];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userName CONTAINS[cd] %@", self.searchBar.text];
            [self.dataArray addObjectsFromArray:[self.allFriends filteredArrayUsingPredicate:predicate]];
            self.tipLB.hidden = self.dataArray.count;
            [super getListData:requestComplete];
        }
            break;
        case JTSearchTypeTeams:
        {
            [self.dataArray removeAllObjects];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamName CONTAINS[cd] %@", self.searchBar.text];
            [self.dataArray addObjectsFromArray:[self.allTeams filteredArrayUsingPredicate:predicate]];
            self.tipLB.hidden = self.dataArray.count;
            [super getListData:requestComplete];
        }
            break;
        case JTSearchTypeMessages:
        {
            self.option.searchContent = self.searchBar.text;
            [[NIMSDK sharedSDK].conversationManager searchAllMessages:self.option result:^(NSError * _Nullable error, NSDictionary<NIMSession *,NSArray<NIMMessage *> *> * _Nullable messages) {
                if (weakSelf.page == 1) {
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.allMessages removeAllObjects];
                }
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
                    [weakSelf.dataArray addObject:source];
                    [weakSelf.allMessages addObject:array];
                }
                weakSelf.tipLB.hidden = weakSelf.dataArray.count;
                [super getListData:requestComplete];
            }];
        }
            break;
        case JTSearchTypeActivities:
        {
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ActivitySearchApi) parameters:@{@"keyword" : self.searchBar.text, @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
                if (weakSelf.page == 1) {
                    [weakSelf.dataArray removeAllObjects];
                    [weakSelf.activities removeAllObjects];
                }
                if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                    NSArray *array = responseObject[@"list"];
                    [weakSelf.dataArray addObjectsFromArray:array];
                    if (array.count < 20) {
                        [self requestRecommendActivityData];
                    }
                } else {
                    [self requestRecommendActivityData];
                }
                [super getListData:requestComplete];
                
            } failure:^(NSError *error) {
                [super getListData:requestComplete];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)requestRecommendActivityData {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(RecommendActivityApi) parameters:nil success:^(id responseObject, ResponseState state) {
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.activities addObjectsFromArray:responseObject[@"list"]];
        }
        weakSelf.tipLB.hidden = weakSelf.dataArray.count+weakSelf.activities.count;
        [weakSelf.tableview reloadData];
    } failure:^(NSError *error) {

    }];
    
}

- (void)handleSearch {
 
    [self.tableview.mj_header setHidden:YES];
    [self.tableview.mj_header beginRefreshing];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.searchType) {
        case JTSearchTypeFriends:
        {
            if (indexPath.row == 0) {
                return [self createNormalTableViewCell:@"好友" textFont:Font(14) textAlignment:NSTextAlignmentLeft];
            }
            else
            {
                JTUserSimpleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userSimpleCellIdentifier];
                NIMUser *user = self.dataArray[indexPath.row-1][@"user"];
                NSString *userName = self.dataArray[indexPath.row-1][@"userName"];
                [cell.avatar setAvatarByUrlString:[user.userInfo.avatarUrl avatarHandleWithSquare:40] defaultImage:DefaultSmallAvatar];
                cell.nameLB.text = userName;
                [cell.genderGradeImageView configGenderView:user.userInfo.gender grade:[JTUserTableViewCell caculateBirthWithBirthDate:user.userInfo.birth]];
                cell.horizontalView.hidden = NO;
                [Utility richTextLabel:cell.nameLB fontNumber:Font(18) andRange:[userName rangeOfString:self.searchBar.text] andColor:BlueLeverColor1];
                return cell;
            }
        }
            break;
        case JTSearchTypeTeams:
        {
            if (indexPath.row == 0) {
                return [self createNormalTableViewCell:@"群聊" textFont:Font(14) textAlignment:NSTextAlignmentLeft];
            }
            else
            {
                JTTeamTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamCellIndentifer];
                NIMTeam *team = self.dataArray[indexPath.row-1][@"team"];
                [cell configTeamCellWithTeam:team];
                [Utility richTextLabel:cell.topLabel fontNumber:Font(18) andRange:[team.teamName rangeOfString:self.searchBar.text] andColor:BlueLeverColor1];
                return cell;
            }
        }
            break;
        case JTSearchTypeMessages:
        {
            if (indexPath.row == 0) {
                return [self createNormalTableViewCell:@"聊天记录" textFont:Font(14) textAlignment:NSTextAlignmentLeft];
            }
            else
            {
                JTGlobalSearchMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:globalSearchMessageIdentifier];
                NSDictionary *source = self.dataArray[indexPath.row-1];
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
        }
            break;
        case JTSearchTypeActivities:
        {
            if (indexPath.row == 0) {
                if (self.dataArray.count) {
                    return [self createNormalTableViewCell:(indexPath.section == 0)?@"活动":@"推荐的活动" textFont:Font(16) textAlignment:NSTextAlignmentLeft];
                }
                else
                {
                    return [self createNormalTableViewCell:(indexPath.section == 0)?@"附近暂时没有活动~":@"推荐的活动" textFont:Font(16) textAlignment:(indexPath.section == 0)?NSTextAlignmentCenter:NSTextAlignmentLeft];
                }
                
            }
            else
            {
                JTActivityJoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityJoinIdentifier];
                cell.rightBtn.hidden = YES;
                cell.delegate = self;
                id source = (indexPath.section == 0)?self.dataArray[indexPath.row-1]:self.activities[indexPath.row-1];
                [cell configActivityJoinTableViewCellWithSource:source indexPath:indexPath];
                cell.groupCountLB.text = [NSString stringWithFormat:@"已有%@人参与，距离你%@",source[@"count"], source[@"distance"]];
                return cell;
            }
        }
            break;
            
        default:
        {
            return [self createNormalTableViewCell:@"" textFont:Font(14) textAlignment:NSTextAlignmentLeft];
        }
            break;
    }
}

- (UITableViewCell *)createNormalTableViewCell:(NSString *)textTitle textFont:(UIFont *)textFont textAlignment:(NSTextAlignment)textAlignment
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.font = textFont;
    cell.textLabel.text = textTitle;
    cell.userInteractionEnabled = NO;
    cell.textLabel.textAlignment = textAlignment;
    cell.textLabel.textColor = BlackLeverColor3;
    cell.contentView.backgroundColor = ([textTitle isEqualToString:@"活动"] || [textTitle isEqualToString:@"推荐的活动"])?BlackLeverColor1:WhiteColor;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchType == JTSearchTypeActivities) {
        return (section == 0)?(self.isSearching?self.dataArray.count+1:self.dataArray.count):(self.activities.count?self.activities.count+1:0);
    }
    return self.dataArray.count?self.dataArray.count+1:0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.searchType == JTSearchTypeActivities)?2:1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchType == JTSearchTypeActivities) {
        return (indexPath.row == 0)?(self.dataArray.count?40:68):140;
    }
    else
    {
        return (indexPath.row == 0)?30:70;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.searchType) {
        case JTSearchTypeFriends:
        {
            NIMUser *user = self.dataArray[indexPath.row-1][@"user"];
            [self startConversation:[NIMSession session:user.userId type:NIMSessionTypeP2P]];
        }
            break;
        case JTSearchTypeTeams:
        {
            NIMTeam *team = self.dataArray[indexPath.row-1][@"team"];
            [self startConversation:[NIMSession session:team.teamId type:NIMSessionTypeTeam]];
        }
            break;
        case JTSearchTypeMessages:
        {
            NSArray *messages = self.allMessages[indexPath.row-1];
            [self.navigationController pushViewController:[[JTMessagesSearchResultViewController alloc] initWithMessages:messages searchKeyword:self.searchBar.text] animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)startConversation:(NIMSession *)session {
    JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
    [self.navigationController pushViewController:sessionVC animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
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

#pragma mark - JTActivityJoinTableViewCellDelegate
- (void)activityJoinTableViewCellTapped:(NSIndexPath *)indexPath {
    
    id source = (indexPath.section == 0)?self.dataArray[indexPath.row-1]:self.activities[indexPath.row-1];
    JTActivityDetailViewController *detailVC = [[JTActivityDetailViewController alloc] initWithActivityID:source[@"activity_id"]];
    detailVC.modalPresentationStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:detailVC animated:NO];
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
        _searchBar.tintColor = BlueLeverColor1;
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

- (NSMutableArray *)activities {
    if (!_activities) {
        _activities = [NSMutableArray array];
    }
    return _activities;
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

- (NSMutableArray *)allMessages {
    if (!_allMessages) {
        _allMessages = [NSMutableArray array];
    }
    return _allMessages;
}


@end
