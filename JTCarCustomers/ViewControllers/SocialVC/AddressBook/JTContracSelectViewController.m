//
//  JTContracSelectViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTMessageMaker.h"
#import "JTActivityShareView.h"
#import "JTUserTableViewCell.h"
#import "JTMutiUserTableViewCell.h"
#import "JTSessionViewController.h"
#import "JTForwardPopupView.h"
#import "JTContracSelectViewController.h"

@interface JTContracSelectViewController () <UITableViewDataSource, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) NSMutableArray *choiceArr;
@property (strong, nonatomic) NSMutableArray *searchArr;
@property (strong, nonatomic) UIButton *completeBT;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UILabel *noResultLB;

@end

@implementation JTContracSelectViewController

- (void)dealloc
{
    NSLog(@"释放 JTContracSelectViewController");
}


- (instancetype)initWithConfig:(id<JTContactConfig>)config
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.config = config;
    }
    return self;
}

- (instancetype)initWithConfig:(id<JTContactConfig>)config message:(NIMMessage *)message
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.config = config;
        self.message = message;
    }
    return self;
}

- (void)setConfig:(id<JTContactConfig>)config
{
    _config = config;
}

- (void)setMessage:(NIMMessage *)message
{
    _message = message;
}

- (void)leftClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightClick:(id)sender {
    if (self.searchController && self.searchController.active) {
        self.searchController.active = NO;
        return;
    }
    switch (self.config.selectType) {
        case JTContactSelectTypeAddTeamMember:
        {
            NSMutableArray *userIDList = [NSMutableArray array];
            for (NSDictionary *source in self.choiceArr) {
                [userIDList addObject:source[@"userID"]];
            }
            NSString *userIDStr = [userIDList componentsJoinedByString:@","];
            __weak typeof(self) weakself = self;
            [[HUDTool shareHUDTool] showHint:@"正在添加..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(InviteUserApi) parameters:@{@"group_id": self.config.teamId, @"uids": userIDStr} success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] showHint:@"添加成功"];
                [weakself dismissViewControllerAnimated:YES completion:nil];
            } failure:^(NSError *error) {
                
            }];
        }
            break;
        case JTContactSelectTypeDeleteTeamMember:
        {
            __weak typeof(self) weakself = self;
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要将该用户移除吗？\n移除后不再接收该用户的群聊信息" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSMutableArray *userIDList = [NSMutableArray array];
                for (NSDictionary *source in self.choiceArr) {
                    [userIDList addObject:source[@"userID"]];
                }
                NSString *userIDStr = [userIDList componentsJoinedByString:@","];
                [[HUDTool shareHUDTool] showHint:@"正在移除..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
                [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(RemoveGroupUserApi) parameters:@{@"group_id": self.config.teamId, @"uids": userIDStr} success:^(id responseObject, ResponseState state) {
                    [[HUDTool shareHUDTool] showHint:@"移除成功"];
                    [weakself dismissViewControllerAnimated:YES completion:nil];
                } failure:^(NSError *error) {
                    
                }];
            }]];
            [self presentViewController:alertVC animated:YES completion:nil];
        }
            break;
        case JTContactSelectTypeMulti:
        {
            NSMutableArray *yunxinIDList = [NSMutableArray array];
            NSMutableArray *userIDList = [NSMutableArray array];
            for (NSDictionary *source in self.choiceArr) {
                [yunxinIDList addObject:source[@"yunxinID"]];
                [userIDList addObject:source[@"userID"]];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
            if (self.finshBlock) {
                self.finshBlock(yunxinIDList, userIDList);
            }
        }
            break;
        default:
            break;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.config.title) {
        self.navigationItem.title = self.config.title;
    }
    [self createTalbeView:UITableViewStylePlain rowHeight:70];
    [self.tableview setTableHeaderView:self.searchController.searchBar];
    [self.tableview setDataSource:self];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview registerClass:[JTMutiUserTableViewCell class] forCellReuseIdentifier:mutiUserIdentifier];
    [self.tableview registerClass:[JTUserTableViewCell class] forCellReuseIdentifier:userTableViewIndentifier];
    [self.tableview setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableview setSectionIndexColor:BlackLeverColor3];
    [self.view addSubview:self.noResultLB];
    
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftClick:)]];
    if (self.config.needMutiSelected) {
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.completeBT]];
    }
    if (self.config.selectType == JTContactSelectTypeThirdShare) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0)?30:70;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.searchController.isActive?nil:self.config.groupTitle;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchController.isActive?1:self.config.groupMember.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.searchController.isActive?self.searchArr.count:[(NSArray *)[self.config.groupMember objectAtIndex:section] count]) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.font = Font(12);
            cell.textLabel.textColor = BlackLeverColor3;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (self.searchController.isActive) {
            cell.textLabel.text = @"联系人";
        }
        else
        {
            NSString *title = [self.config.groupTitle objectAtIndex:indexPath.section];
            cell.textLabel.text = title;
        }
        return cell;
    }
    else
    {
        NSDictionary *source = self.searchController.isActive?[self.searchArr objectAtIndex:indexPath.row-1]:[[self.config.groupMember objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
        if (self.config.needMutiSelected) {
            JTMutiUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mutiUserIdentifier];
            [cell.avatarImageView setAvatarByUrlString:[source[@"avatar"] avatarHandleWithSquare:80] defaultImage:[UIImage imageNamed:@"nav_default"]];
            [cell.detailLB setText:source[@"name"]];
            if ([self.config.alreadySelectedMemberId containsObject:source[@"yunxinID"]] || [self.config.alreadySelectedMemberId containsObject:@([source[@"yunxinID"] integerValue])] ||
                [self.config.alreadySelectedMemberId containsObject:source[@"userID"]] ||
                [self.config.alreadySelectedMemberId containsObject:@([source[@"userID"] integerValue])]) {
                [cell.choiceBT setImage:[UIImage imageNamed:@"icon_accessory_pressed"] forState:UIControlStateNormal];
            }
            else
            {
                if ([self.choiceArr containsObject:source]) {
                    [cell.choiceBT setImage:[UIImage imageNamed:@"icon_accessory_selected"] forState:UIControlStateNormal];
                }
                else
                {
                    [cell.choiceBT setImage:[UIImage imageNamed:@"icon_accessory_normal"] forState:UIControlStateNormal];
                }
            }
            return cell;
        }
        else
        {
            JTUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userTableViewIndentifier];
            [cell.avatar setAvatarByUrlString:[source[@"avatar"] avatarHandleWithSquare:80] defaultImage:[UIImage imageNamed:@"nav_default"]];
            [cell.topLabel setText:source[@"name"]];
            cell.genderView.hidden = YES;
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        NSDictionary *source = self.searchController.isActive?[self.searchArr objectAtIndex:indexPath.row-1]:[[self.config.groupMember objectAtIndex:indexPath.section] objectAtIndex:indexPath.row-1];
        if (self.config.selectType == JTContactSelectTypeThirdShare) {
            if (self.searchController && self.searchController.active) {
                self.searchController.active = NO;
            }
            NIMSession *session = [NIMSession session:source[@"userID"] type:NIMSessionTypeP2P];
            JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
            [sessionVC sendMessage:self.message];
            UITabBarController *tabBarController = (UITabBarController *)self.presentingViewController;
            UINavigationController *navigationController = (UINavigationController *)[tabBarController selectedViewController];
            [self dismissViewControllerAnimated:NO completion:^{
                if (tabBarController.selectedIndex == 0) {
                    sessionVC.hidesBottomBarWhenPushed = YES;
                    UIViewController *root = navigationController.viewControllers[0];
                    navigationController.viewControllers = @[root, sessionVC];
                }
                else
                {
                    [tabBarController setSelectedIndex:0];
                    [[tabBarController.selectedViewController topViewController] setHidesBottomBarWhenPushed:YES];
                    [sessionVC setHidesBottomBarWhenPushed:YES];
                    [tabBarController.selectedViewController pushViewController:sessionVC animated:YES];
                    [navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
        else if (self.config.selectType == JTContactSelectTypeShareActivity ||
                 self.config.selectType == JTContactSelectTypeRepeatMessage ||
                 self.config.selectType == JTContactSelectTypeRepeatCard ||
                 self.config.selectType == JTContactSelectTypeShareInfomation ||
                 self.config.selectType == JTContactSelectTypeShareTeam ||
                 self.config.selectType == JTContactSelectTypeShareStore)
        {
            [self showForwardPopupViewWithSource:source];
        }
       
        else
        {
            if (self.config.needMutiSelected) {
                if (![self.config.alreadySelectedMemberId containsObject:source[@"yunxinID"]] && ![self.config.alreadySelectedMemberId containsObject:@([source[@"yunxinID"] integerValue])] && ![self.config.alreadySelectedMemberId containsObject:source[@"userID"]] && ![self.config.alreadySelectedMemberId containsObject:@([source[@"userID"] integerValue])]) {
                    if ([self.choiceArr containsObject:source]) {
                        [self.choiceArr removeObject:source];
                    }
                    else
                    {
                        [self.choiceArr addObject:source];
                    }
                    if (self.choiceArr.count > 0) {
                        [self.completeBT setTitle:[NSString stringWithFormat:@"%@(%lu)", @"完成", (unsigned long)self.choiceArr.count] forState:UIControlStateNormal];
                        [self.completeBT setSelected:YES];
                        [self.completeBT setUserInteractionEnabled:YES];
                    }
                    else
                    {
                        [self.completeBT setTitle:@"完成" forState:UIControlStateNormal];
                        [self.completeBT setSelected:NO];
                        [self.completeBT setUserInteractionEnabled:NO];
                    }
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
            else
            {
                if (self.searchController && self.searchController.active) {
                    self.searchController.active = NO;
                }
                __weak typeof(self) weakself = self;
                [self dismissViewControllerAnimated:YES completion:^{
                    if (weakself.finshBlock) {
                        weakself.finshBlock(@[source[@"yunxinID"]], @[source[@"userID"]]);
                    }
                }];
            }
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)showForwardPopupViewWithSource:(NSDictionary *)source {
    NSDictionary *progem;
    JTSelectType seletedType;
    if (self.config.selectType == JTContactSelectTypeRepeatMessage) {
        progem = @{@"message" : self.config.source, @"contract" : source};
        seletedType = JTSelectTypeRepeatMessage;
    }
    else if (self.config.selectType == JTContactSelectTypeShareInfomation)
    {
        progem = @{@"infomation" : self.config.source, @"contract" : source};
        seletedType = JTSelectTypeShareInfomation;
    }
    else if (self.config.selectType == JTContactSelectTypeShareActivity)
    {
        progem = @{@"activity" : self.config.source, @"contract" : source};
        seletedType = JTSelectTypeShareActivity;
    }
    else if (self.config.selectType == JTContactSelectTypeShareTeam)
    {
        progem = @{@"teamcard" : self.config.source, @"contract" : source};
        seletedType = JTSelectTypeShareTeam;
    }
    else if (self.config.selectType == JTContactSelectTypeShareStore)
    {
        progem = @{@"store" : self.config.source, @"contract" : source};
        seletedType = JTSelectTypeShareStore;
    }
    else if (self.config.selectType == JTContactSelectTypeRepeatCard)
    {
        progem = @{@"session" : self.config.source, @"contract" : source};
        seletedType = JTSelectTypeShareStore;
    }
    else
    {
        progem = @{};
        seletedType = JTSelectTypeRepeatMessage;
    }
    JTForwardPopupView *shareView = [[JTForwardPopupView alloc] initWithSource:progem selectType:seletedType sessionType:NIMSessionTypeP2P];
    __weak typeof(self)weakSelf = self;
    shareView.callBack = ^(NSString *content, JTPopupActionType actionType) {
        if (actionType == JTPopupActionTypeDefault && weakSelf.callBack) {
            weakSelf.callBack(@[source[@"yunxinID"]], @[source[@"userID"]], content);
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    };
    [[Utility mainWindow] presentView:shareView animated:YES completion:nil];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSMutableArray *array = [NSMutableArray array];
    [self.config.groupMember enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchController.searchBar.text];
        [array addObjectsFromArray:[obj filteredArrayUsingPredicate:predicate]];
    }];
    [self.searchArr removeAllObjects];
    if ((array && array.count > 0) || searchController.searchBar.text.length == 0) {
        [self.searchArr addObjectsFromArray:array];
        [self.noResultLB setHidden:YES];
    }
    else
    {
        [self.noResultLB setHidden:NO];
        [self.noResultLB setAttributedText:[self configNoResultLB:[NSString stringWithFormat:@"\"%@\"", searchController.searchBar.text]]];
    }
    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)choiceArr
{
    if (!_choiceArr) {
        _choiceArr = [NSMutableArray array];
    }
    return _choiceArr;
}

- (NSMutableArray *)searchArr
{
    if (!_searchArr) {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}

- (UIButton *)completeBT
{
    if (!_completeBT) {
        _completeBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _completeBT.titleLabel.font = Font(14);
        [_completeBT setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_completeBT setTitleColor:BlackLeverColor5 forState:UIControlStateSelected];
        [_completeBT setTitle:@"完成" forState:UIControlStateNormal];
        [_completeBT addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        [_completeBT setFrame:CGRectMake(0, 0, 100, 30)];
        [_completeBT setUserInteractionEnabled:NO];
        [_completeBT setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    }
    return _completeBT;
}

- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(0, 0, App_Frame_Width, 44);
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.backgroundColor = BlackLeverColor1;
        _searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchController.searchBar.clearsContextBeforeDrawing = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
    }
    return _searchController;
}

- (void)applicationDidEnterBackground
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UILabel *)noResultLB
{
    if (!_noResultLB) {
        _noResultLB = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight + kTopBarHeight + 100, App_Frame_Width, 100)];
        _noResultLB.textColor = BlackLeverColor3;
        _noResultLB.font = Font(15);
        _noResultLB.textAlignment = NSTextAlignmentCenter;
        _noResultLB.hidden = YES;
    }
    return _noResultLB;
}

- (NSMutableAttributedString *)configNoResultLB:(NSString *)content
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"没有搜索到%@的相关联系人", content]];
    NSRange range = [attributedString.string rangeOfString:content];
    [attributedString addAttribute:NSForegroundColorAttributeName value:YellowColor range:range];
    return attributedString;
}
@end
