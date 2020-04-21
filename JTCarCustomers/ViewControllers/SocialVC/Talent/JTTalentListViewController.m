//
//  JTTalentListViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTTalentTableHeadView.h"
#import "JTTalentTableViewCell.h"
#import "JTTalentListViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTSessionViewController.h"

@interface JTTalentListViewController () <UITableViewDataSource, JTTalentTableHeadViewDelegate, JTTalentTableViewCellDelegate>

@property (nonatomic, strong) JTTalentTableHeadView *headView;
@property (nonatomic, strong) UILabel *tipLB;

@property (nonatomic, strong) NSMutableArray *categoryDatas;
@property (nonatomic, assign) BOOL isCreate;
@property (nonatomic, copy) NSString *category;


@end

@implementation JTTalentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"达人列表"];
    [self.view addSubview:self.headView];
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectZero rowHeight:140 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview setDataSource: self];
    [self setShowTableRefreshFooter:YES];
    [self setShowTableRefreshHeader:YES];
    [self.tableview registerClass:[JTTalentTableViewCell class] forCellReuseIdentifier:talentTableViewIndentify];
    [self.view addSubview:self.tipLB];
    
    //获取分类列表
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/chat/expert/getExPertCategory") parameters:nil success:^(id responseObject, ResponseState state) {
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf handleTalentTags:responseObject[@"list"]];
        }
    } failure:^(NSError *error) {
        weakSelf.tipLB.hidden = weakSelf.dataArray.count;
    }];
}

- (void)handleTalentTags:(NSArray *)category {
    __weak typeof(self)weakSelf = self;
    [category enumerateObjectsUsingBlock:^(NSDictionary *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JTWordItem *item = [JTTalentListViewController creatItemWithTitle:[NSString stringWithFormat:@"%@",obj[@"name"]] isSeleted:(idx == 0)?YES:NO tagID:[NSString stringWithFormat:@"%@",obj[@"id"]]];
        if (idx == 0) {
            weakSelf.category = item.tagID;
        }
        [weakSelf.categoryDatas addObject:item];
    }];
    CGFloat hight = [JTTalentTableHeadView getViewHeightWithTags:weakSelf.categoryDatas width:App_Frame_Width];
    self.headView.talentTags = self.categoryDatas;
    [self.headView reloaData];
    [self.headView setHeight:hight];
    [self.tableview setFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), App_Frame_Width, APP_Frame_Height-CGRectGetHeight(self.headView.frame)-kStatusBarHeight-kTopBarHeight)];
    [self staticRefreshFirstTableListData];
}

#pragma mark 获取达人列表
- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(ExpertListApi) parameters:@{@"category" : weakSelf.category, @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        weakSelf.tipLB.hidden = weakSelf.dataArray.count;
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTTalentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:talentTableViewIndentify];
    cell.delegate = self;
    [cell configTalentTableViewCellWithTalentInfo:self.dataArray[indexPath.section] indexPath:indexPath];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0?0:10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    return [tableView fd_heightForCellWithIdentifier:talentTableViewIndentify cacheByIndexPath:indexPath configuration:^(id cell) {
        [cell configTalentTableViewCellWithTalentInfo:weakSelf.dataArray[indexPath.section] indexPath:indexPath];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self talentTableViewCellDialogBoxClick:indexPath];
}

#pragma mark JTTalentTableHeadViewDelegate
- (void)talentTableHeadViewTagClick:(NSString *)tagID {
    self.category = tagID;
    [self staticRefreshFirstTableListData];
}

#pragma mark JTTalentTableViewCellDelegate
- (void)talentTableViewCellDialogBoxClick:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = self.dataArray[indexPath.section];
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:dictionary[@"accid"]];
    if (!user.userInfo.nickName) {
        __weak typeof(self)weakSelf = self;
        [[NIMSDK sharedSDK].userManager fetchUserInfos:@[dictionary[@"accid"]] completion:^(NSArray<NIMUser *> * _Nullable users, NSError * _Nullable error) {
            if (users) {
                [weakSelf handleConversationWithYunXinID:dictionary[@"accid"]];
            }
        }];
    } else {
        [self handleConversationWithYunXinID:dictionary[@"accid"]];
    }
}

- (void)handleConversationWithYunXinID:(NSString *)yunXinID {
    NIMSession *session = [NIMSession session:yunXinID type:NIMSessionTypeP2P];
    JTSessionViewController *sessionVC = [[JTSessionViewController alloc] initWithSession:session];
    if (self.tabBarController.selectedIndex == 0) {
        sessionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:sessionVC animated:YES];
        UIViewController *root = self.navigationController.viewControllers[0];
        self.navigationController.viewControllers = @[root, sessionVC];
    }
    else
    {
        [self.tabBarController setSelectedIndex:0];
        [[self.tabBarController.selectedViewController topViewController] setHidesBottomBarWhenPushed:YES];
        [sessionVC setHidesBottomBarWhenPushed:YES];
        [self.tabBarController.selectedViewController pushViewController:sessionVC animated:YES];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

+ (JTWordItem *)creatItemWithTitle:(NSString *)title isSeleted:(BOOL)isSeleted tagID:(NSString *)tagID{
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = title;
    item.isSeleted = isSeleted;
    item.tagID = tagID;
    return item;
}

- (JTTalentTableHeadView *)headView {
    if (!_headView) {
        _headView = [[JTTalentTableHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, 60)];
        _headView.delegate = self;
    }
    return _headView;
}

- (NSMutableArray *)categoryDatas {
    if (!_categoryDatas) {
        _categoryDatas = [NSMutableArray array];
    }
    return _categoryDatas;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"暂无该类型达人数据~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}


@end
