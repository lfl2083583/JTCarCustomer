//
//  JTTeamInfoEditeViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "ZTObtainPhotoTool.h"
#import "ZTFileNameTool.h"
#import "JTTeamInfoEditeViewController.h"
#import "JTCreateTeamTitleViewController.h"
#import "JTCreatTeamClassifyViewController.h"
#import "JTCreatTeamLocationViewController.h"
#import "UIViewController+BackButtonHandler.h"

@implementation JTTeamInfoEditeTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bottomImgeView];
        [self addSubview:self.topBtn];
    }
    return self;
}

- (void)topBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(changeTeamAvatar)]) {
        [_delegate changeTeamAvatar];
    }
}

- (UIImageView *)bottomImgeView {
    if (!_bottomImgeView) {
        _bottomImgeView = [[UIImageView alloc] initWithFrame:self.bounds];
        _bottomImgeView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _bottomImgeView;
}

- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [[UIButton alloc] initWithFrame:self.bounds];
        _topBtn.backgroundColor = RGBCOLOR(0, 0, 0, 0.4);
        _topBtn.titleLabel.font = Font(18);
        _topBtn.titleEdgeInsets = UIEdgeInsetsMake(kStatusBarHeight+kTopBarHeight, 0, 0, 0);
        [_topBtn setTitle:@"点击更换群头像" forState:UIControlStateNormal];
        [_topBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_topBtn addTarget:self action:@selector(topBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}

@end

@interface JTTeamInfoEditeViewController () <UITableViewDataSource, JTTeamInfoEditeTableHeadViewDelegate>

@property (nonatomic, strong) JTTeamInfoEditeTableHeadView *tableHeadView;
@property (nonatomic, strong) UIImage *avatar;
@property (nonatomic, assign) JTTeamPositionType positionType;
@property (nonatomic, assign) JTTeamCategoryType category;
@property (nonatomic, assign) BOOL isEdite;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *teamName;
@property (nonatomic, copy) NSString *teamDescribe;

@end

static NSString *normalIdentifier = @"JTTeamInfoEditeTableViewCell";

@implementation JTTeamInfoEditeViewController

- (instancetype)initWithTeam:(NIMTeam *)team loctionInfo:(id)loctionInfo {
    self = [super init];
    if (self) {
        self.team = team;
        self.loctionInfo = loctionInfo;
    }
    return self;
}

- (BOOL)navigationShouldPopOnBackButton {
    if (self.isEdite) {
        __weak typeof(self)weakSelf = self;
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"将此次编辑保存" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }]];
        [alertVC addAction:[UIAlertAction actionWithTitle:@"保存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf rightBarButtonItemClick:nil];
        }]];
        [self presentViewController:alertVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)rightBarButtonItemClick:(id)sender {
    if (!self.teamName && !self.address && !self.category && !self.avatar) {
        [[HUDTool shareHUDTool] showHint:@"请先编辑资料，再提交" yOffset:0];
        return;
    }
    NSMutableDictionary *progrem = [NSMutableDictionary dictionary];
    [progrem setValue:self.team.teamId forKey:@"group_id"];
    if (self.teamName) {
        [progrem setValue:self.teamName forKey:@"name"];
    }
    if (self.teamDescribe) {
        [progrem setValue:self.teamDescribe forKey:@"describe"];
    }
    if (self.category) {
        [progrem setValue:@(self.category) forKey:@"category"];
    }
    if (self.positionType) {
        [progrem setValue:@(self.positionType) forKey:@"position"];
    }
    if (self.address) {
        [progrem setValue:self.address forKey:@"address"];
        [progrem setValue:self.lat forKey:@"latitude"];
        [progrem setValue:self.lng forKey:@"longitude"];
    }
    
    __weak typeof (self)weakSelf = self;
    [[HUDTool shareHUDTool] showHint:@"修改资料中..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    if (self.avatar) {
        [[HttpRequestTool sharedInstance] uploadWithFileNames:[ZTFileNameTool showFileNamesForTeamAvatar] uploadFileArr:@[self.avatar] success:^(id responseObject) {
            if (responseObject && [responseObject isKindOfClass:[NSArray class]]) {
                NSArray *array = responseObject;
                NSString *teamAvatarUrl = [array firstObject];
                [progrem setValue:teamAvatarUrl forKey:@"head_image"];
                [weakSelf requestForTeamInfoEditeWithProgrem:progrem];
            }
        } failure:^(NSError *error) {
            
        }];
    }
    else
    {
        [self requestForTeamInfoEditeWithProgrem:progrem];
    }
}

- (void)requestForTeamInfoEditeWithProgrem:(NSDictionary *)progem {
    __weak typeof (self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EditGroupApi) parameters:progem success:^(id responseObject, ResponseState state) {
        CCLOG(@"%@",responseObject);
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            [[HUDTool shareHUDTool] showHint:@"修改成功" yOffset:0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:kJTTeamInfoUpdatedNotification object:nil];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑群资料";
    [self setupComponent];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeFullScreen rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    self.tableview.dataSource = self;
    self.tableview.tableHeaderView = self.tableHeadView;
    [self.tableHeadView.bottomImgeView sd_setImageWithURL:[NSURL URLWithString:[self.team.avatarUrl avatarHandleWithSquare:App_Frame_Width]]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


- (void)setupComponent {
    JTTeamCategoryType category = [JTTeamInfoHandle showTeamCategoryWithTeam:self.team];
    NSString *categoryName = [self getTeamCategoryNameWithCategoryType:category];
    NSString *address = self.loctionInfo[@"address"]?self.loctionInfo[@"address"]:@"未设置";
    JTWordItem *item1 = [self createItemWithTitle:@"群资料" subtitle:@""];
    JTWordItem *item2 = [self createItemWithTitle:@"群地点" subtitle:address];
    JTWordItem *item3 = [self createItemWithTitle:@"群分类" subtitle:categoryName];
    [self.dataArray addObjectsFromArray:@[item1, item2, item3]];
}

- (JTWordItem *)createItemWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = title;
    item.subTitle = subtitle;
    return item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalIdentifier];
        cell.textLabel.font = Font(16);
        cell.detailTextLabel.font = Font(16);
        cell.detailTextLabel.textColor = BlackLeverColor3;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JTWordItem *item = self.dataArray[indexPath.row];
    __weak typeof(self)weakSelf = self;
    if ([item.title isEqualToString:@"群资料"]) {
        [self.navigationController pushViewController:[[JTCreateTeamTitleViewController alloc] initWithTeam:self.team callBack:^(UIImage *image, NSString *title, NSString *describe) {
            weakSelf.avatar = image;
            weakSelf.teamName = title;
            weakSelf.teamDescribe = describe;
            if (image) {
                weakSelf.tableHeadView.bottomImgeView.image = image;
            }
            weakSelf.isEdite = YES;
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
            [weakSelf.tableview reloadData];
        }] animated:YES];
    } else if ([item.title isEqualToString:@"群地点"]) {
        [self.navigationController pushViewController:[[JTCreatTeamLocationViewController alloc] initWithTeam:self.team callBack:^(JTTeamPositionType positionType, NSString *address, NSString *lng, NSString *lat) {
            weakSelf.positionType = positionType;
            weakSelf.address = address;
            weakSelf.lat = lat;
            weakSelf.lng = lng;
            item.subTitle = address;
            weakSelf.isEdite = YES;
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
            [weakSelf.tableview reloadData];
        }] animated:YES];
    } else if ([item.title isEqualToString:@"群分类"]) {
        [self.navigationController pushViewController:[[JTCreatTeamClassifyViewController alloc] initWithTeam:self.team callBack:^(JTTeamCategoryType category) {
            weakSelf.category = category;
            weakSelf.isEdite = YES;
            item.subTitle = [weakSelf getTeamCategoryNameWithCategoryType:category];
            weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
            [weakSelf.tableview reloadData];
        }] animated:YES];
    }
}

#pragma mark JTTeamInfoEditeTableHeadViewDelegate
- (void)changeTeamAvatar {
    __weak typeof(self)weakSelf = self;
    [[ZTObtainPhotoTool shareObtainPhotoTool] show:self success:^(UIImage *image) {
        weakSelf.avatar = image;
        weakSelf.isEdite = YES;
        weakSelf.tableHeadView.bottomImgeView.image = image;
        weakSelf.navigationItem.rightBarButtonItem.enabled = YES;
    } cancel:^{
        
    }];
}

- (NSString *)getTeamCategoryNameWithCategoryType:(JTTeamCategoryType)category {
    NSString *categoryName = @"";
    switch (category) {
        case JTTeamCategoryTypeCarFriend:
            categoryName = @"车友";
            break;
        case JTTeamCategoryTypeSport:
            categoryName = @"运动";
            break;
        case JTTeamCategoryTypeMakeFriend:
            categoryName = @"交友";
            break;
        case JTTeamCategoryTypePlay:
            categoryName = @"玩乐";
            break;
        case JTTeamCategoryTypeLive:
            categoryName = @"生活";
            break;
        case JTTeamCategoryTypeGame:
            categoryName = @"游戏";
            break;
        case JTTeamCategoryTypeTheSameCity:
            categoryName = @"同城";
            break;
        case JTTeamCategoryTypeInterest:
            categoryName = @"兴趣";
            break;
        default:
            break;
    }
    return categoryName;
}

- (JTTeamInfoEditeTableHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTTeamInfoEditeTableHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableview.width, self.tableview.width)];
        _tableHeadView.delegate = self;
    }
    return _tableHeadView;
}
@end

