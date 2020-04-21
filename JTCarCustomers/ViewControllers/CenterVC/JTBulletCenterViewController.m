//
//  JTBulletCenterViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBulletCenterViewController.h"
#import "JTBulletCenterTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface JTBulletCenterViewController () <UITableViewDataSource>

@property (nonatomic, strong) UILabel *tipLB;
@property (nonatomic, strong) UIButton *rightBarBtn;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) NSMutableArray *seletedArray;

@end

@implementation JTBulletCenterViewController

- (instancetype)initWithUserID:(NSString *)userID {
    self = [super init];
    if (self) {
        _userID = userID;
    }
    return self;
}

- (void)rightBarButtonItemClick:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    [self animationBottomView:sender.selected];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"弹幕中心";
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:60 sectionHeaderHeight:22 sectionFooterHeight:0];
    [self.tableview registerClass:[JTBulletCenterTableViewCell class] forCellReuseIdentifier:bulletCenterCellIndentify];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setShowTableRefreshHeader:YES];
    [self.tableview setDataSource:self];
    [self.tableview setBackgroundColor:BlackLeverColor1];
    [self.view setBackgroundColor:BlackLeverColor1];
    [self.view addSubview:self.tipLB];
    [self.view addSubview:self.bottomView];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.rightBarBtn]];
    [self staticRefreshFirstTableListData];
}

- (void)bottomBtnClick:(UIButton *)sender
{
    self.leftBtn.selected = NO;
    self.rightBtn.selected = NO;
    sender.selected = YES;
    __weak typeof(self)weakSelf = self;
    if (sender == self.rightBtn) {
        if (self.seletedArray.count) {
            NSMutableArray *array = [NSMutableArray array];
            [self.seletedArray enumerateObjectsUsingBlock:^(NSIndexPath *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSDictionary *dictionary = weakSelf.dataArray[obj.section];
                [array addObject:[dictionary objectForKey:@"barrage_id"]];
            }];
            NSString *value = [array componentsJoinedByString:@","];
            [self deleteBulletsWithProgrem:@{@"id" : value}];
            
        } else {
            
            [[HUDTool shareHUDTool] showHint:@"请选择需要删除的弹幕" yOffset:0];
        }
    }
    else
    {
        [self.seletedArray removeAllObjects];
        for (NSInteger i = 0; i < self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:i];
            [self.seletedArray addObject:indexPath];
        }
        [self.tableview reloadData];
        [self removeAllBullet];
        
    }
}

- (void)removeAllBullet {
    __weak typeof(self)weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"删除弹幕" message:@"确定要清除所有弹幕吗" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf deleteBulletsWithProgrem:@{@"id" : @"all"}];
    }]];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)deleteBulletsWithProgrem:(NSDictionary *)progrem {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(DeleteBarrageApi) parameters:progrem success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"删除成功" yOffset:0];
        [weakSelf.seletedArray removeAllObjects];
        [weakSelf staticRefreshFirstTableListData];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userBullentsChangedNotificationName" object:nil];
    } failure:^(NSError *error) {
        
    }];
}

- (void)getListData:(void (^)(void))requestComplete {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(BarrageListApi) parameters:@{@"uid" : self.userID, @"page" : @(self.page)} success:^(id responseObject, ResponseState state) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            NSArray *array = responseObject[@"list"];
            [weakSelf.dataArray addObjectsFromArray:array];
            weakSelf.tipLB.hidden = weakSelf.dataArray.count;
        }
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTBulletCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bulletCenterCellIndentify];
    cell.checkBox.image = ([self.seletedArray containsObject:indexPath])?[UIImage imageNamed:@"icon_accessory_selected"]:[UIImage imageNamed:@"icon_accessory_normal"];
    [self configBulletCell:cell source:self.dataArray[indexPath.section]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self)weakSelf = self;
    CGFloat height = [tableView fd_heightForCellWithIdentifier:bulletCenterCellIndentify cacheByIndexPath:indexPath configuration:^(JTBulletCenterTableViewCell *cell) {
        [weakSelf configBulletCell:cell source:weakSelf.dataArray[indexPath.section]];
    }];
    return height>30?height:30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.seletedArray containsObject:indexPath]) {
        [self.seletedArray removeObject:indexPath];
    } else {
        [self.seletedArray addObject:indexPath];
    }
    if (self.seletedArray.count == 1 ) {
        [self animationBottomView:YES];
        [self.rightBarBtn setSelected:YES];
    } else if (self.seletedArray.count == 0) {
        [self animationBottomView:NO];
        [self.rightBarBtn setSelected:NO];
    } else if (self.seletedArray.count == self.dataArray.count) {
        [self.rightBtn setSelected:NO];
        [self.leftBtn setSelected:YES];
    } else {
        [self.rightBtn setSelected:YES];
        [self.leftBtn setSelected:NO];
    }
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)configBulletCell:(JTBulletCenterTableViewCell *)cell source:(id)source
{
    
    [cell.avatarView setAvatarByUrlString:[source[@"avatar"] avatarHandleWithSquare:50] defaultImage:DefaultSmallAvatar];
    NSString *rangeStr = [NSString stringWithFormat:@"%@：", source[@"nick_name"]];
    NSString *content = [NSString stringWithFormat:@"%@%@", rangeStr ,source[@"message"]];
    [cell.rightLB setText:content];
    [Utility richTextLabel:cell.rightLB fontNumber:Font(16) andRange:[content rangeOfString:rangeStr] andColor:BlueLeverColor4];
    
    CGSize size = [Utility getTextString:content textFont:Font(16) frameWidth:App_Frame_Width-100 attributedString:nil];
    CGFloat radius = (size.height+10 > 30)?6:15;
    cell.bottomView.layer.cornerRadius = radius;
    [cell.rightLB mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width+5);
    }];
    
}

- (void)animationBottomView:(BOOL)showUp
{
    __weak typeof(self)weakSelf = self;
    if (showUp == YES) {
        [self.tableview setHeight:APP_Frame_Height-kStatusBarHeight-kTopBarHeight-80];
        [UIView animateWithDuration:0.26 animations:^{
            [weakSelf.bottomView setY:APP_Frame_Height-80];
        }];
    }
    else
    {
        [self.tableview setHeight:APP_Frame_Height-kStatusBarHeight-kTopBarHeight];
        [UIView animateWithDuration:0.26 animations:^{
            [weakSelf.bottomView setY:APP_Frame_Height];
        }];
    }
}

- (UIButton *)rightBarBtn
{
    if (!_rightBarBtn) {
        _rightBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, kTopBarHeight)];
        [_rightBarBtn.titleLabel setFont:Font(16)];
        [_rightBarBtn setTitle:@"编辑" forState:UIControlStateNormal];
        [_rightBarBtn setTitle:@"取消" forState:UIControlStateSelected];
        [_rightBarBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_rightBarBtn addTarget:self action:@selector(rightBarButtonItemClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBarBtn;
}


- (NSMutableArray *)seletedArray {
    if (!_seletedArray) {
        _seletedArray = [NSMutableArray array];
    }
    return _seletedArray;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height, App_Frame_Width, 80)];
        [_bottomView addSubview:self.leftBtn];
        [_bottomView addSubview:self.rightBtn];
    }
    return _bottomView;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [[UIButton alloc] init];
        _leftBtn.layer.cornerRadius = 4;
        _leftBtn.layer.masksToBounds = YES;
        [_leftBtn setFrame:CGRectMake(15, 17.5, (App_Frame_Width-40)/2.0, 45)];
        [_leftBtn setTitle:@"清空弹幕" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_leftBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
        [_leftBtn setBackgroundImage:[UIImage graphicsImageWithColor:WhiteColor rect:self.leftBtn.bounds] forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:[UIImage graphicsImageWithColor:BlueLeverColor1 rect:self.leftBtn.bounds] forState:UIControlStateSelected];
        [_leftBtn.titleLabel setFont:Font(16)];
        [_leftBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] init];
        _rightBtn.layer.cornerRadius = 4;
        _rightBtn.layer.masksToBounds = YES;
        [_rightBtn setFrame:CGRectMake(CGRectGetMaxX(self.leftBtn.frame)+10, 17.5, (App_Frame_Width-40)/2.0, 45)];
        [_rightBtn setTitle:@"删除所选" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_rightBtn setTitleColor:WhiteColor forState:UIControlStateSelected];
        [_rightBtn setBackgroundColor:BlueLeverColor1];
        [_rightBtn setBackgroundImage:[UIImage graphicsImageWithColor:WhiteColor rect:self.rightBtn.bounds] forState:UIControlStateNormal];
        [_rightBtn setBackgroundImage:[UIImage graphicsImageWithColor:BlueLeverColor1 rect:self.rightBtn.bounds] forState:UIControlStateSelected];
        [_rightBtn.titleLabel setFont:Font(16)];
        [_rightBtn setSelected:YES];
        [_rightBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UILabel *)tipLB {
    if (!_tipLB) {
        _tipLB = [[UILabel alloc] initWithFrame:CGRectMake(15, (APP_Frame_Height-22)/2.0-kTopBarHeight, App_Frame_Width-30, 22)];
        _tipLB.textColor = BlackLeverColor3;
        _tipLB.font = Font(16);
        _tipLB.textAlignment = NSTextAlignmentCenter;
        _tipLB.text = @"暂时没有弹幕~";
        _tipLB.hidden = YES;
    }
    return _tipLB;
}
@end
