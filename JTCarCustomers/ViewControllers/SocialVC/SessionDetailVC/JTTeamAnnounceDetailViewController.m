//
//  JTTeamAnnounceDetailViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIView+Spring.h"
#import "JTBaseSpringView.h"
#import "JTTeamAnnounceTipView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "JTTeamAnnounceEditViewController.h"
#import "JTTeamAnnounceDetailViewController.h"

@implementation JTTeamAnnounceTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLB];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (UILabel *)leftLB {
    if (!_leftLB) {
        _leftLB = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.width-44, 40)];
        _leftLB.font = Font(24);
        _leftLB.text = @"群公告";
    }
    return _leftLB;
}

@end

@implementation JTTeamAnnounceTableFootView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.centerBtn];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (void)centerBtnClick:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(announceTableFootViewClick)]) {
        [_delegate announceTableFootViewClick];
    }
}

- (JTGradientButton *)centerBtn {
    if (!_centerBtn) {
        _centerBtn = [[JTGradientButton alloc] initWithFrame:CGRectMake((self.width - 300) / 2.0, 15, 300, 45)];
        _centerBtn.titleLabel.font = Font(16);
        [_centerBtn setTitle:@"编辑公告" forState:UIControlStateNormal];
        [_centerBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _centerBtn;
}

@end

@implementation JTTeamAnnounceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLB];
        [self.contentView addSubview:self.timeLB];
        [self.contentView addSubview:self.rightLB];
        [self.contentView addSubview:self.bottomView];
        [self.contentView addSubview:self.bottomLB];
        
        __weak typeof(self)weakSelf = self;
        [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(22);
            make.top.equalTo(weakSelf.contentView.mas_top).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-22);
        }];
        [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(22);
            make.top.equalTo(weakSelf.titleLB.mas_bottom).offset(5);
            make.right.equalTo(weakSelf.rightLB.mas_right).offset(-15);
        }];
        [self.rightLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.timeLB.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-22);
            make.width.mas_equalTo (120);
        }];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left);
            make.top.equalTo(weakSelf.timeLB.mas_bottom).offset(5);
            make.right.equalTo(weakSelf.contentView.mas_right);
            make.height.mas_equalTo(0.5);
        }];
        [self.bottomLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentView.mas_left).offset(22);
            make.top.equalTo(weakSelf.bottomView.mas_bottom).offset(15);
            make.right.equalTo(weakSelf.contentView.mas_right).offset(-22);
            make.bottom.equalTo(weakSelf.contentView.mas_bottom).offset(-15);
        }];
    }
    return self;
}

- (void)configCellWithAnnounce:(id)announce {
    if (announce && [announce isKindOfClass:[NSDictionary class]]) {
        self.titleLB.text = announce[@"title"];
        self.timeLB.text = announce[@"create_time"];
        self.bottomLB.text = announce[@"content"];
        self.rightLB.text = [NSString stringWithFormat:@"%@人已读",announce[@"number"]];
    }
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLB.font = Font(16);
        _titleLB.textColor = BlackLeverColor6;
    }
    return _titleLB;
}

- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLB.font = Font(12);
        _timeLB.textColor = BlackLeverColor3;
    }
    return _timeLB;
}

- (UILabel *)rightLB {
    if (!_rightLB) {
        _rightLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLB.font = Font(12);
        _rightLB.textColor = BlueLeverColor1;
        _rightLB.textAlignment = NSTextAlignmentRight;
    }
    return _rightLB;
}

- (UILabel *)bottomLB {
    if (!_bottomLB) {
        _bottomLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomLB.font = Font(16);
        _bottomLB.textColor = BlackLeverColor6;
        _bottomLB.numberOfLines = 0;
    }
    return _bottomLB;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = BlackLeverColor2;
    }
    return _bottomView;
}

@end


@interface JTTeamAnnounceDetailViewController () <UITableViewDelegate, UITableViewDataSource, JTTeamAnnounceDelegate>
{
    NSString *announceID;
    BOOL isOwner;
}

@property (nonatomic, strong) JTTeamAnnounceTableHeadView *tableHeadView;
@property (nonatomic, strong) JTTeamAnnounceTableFootView *tableFootView;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation JTTeamAnnounceDetailViewController

- (instancetype)initWithTeamAnnounce:(id)announce team:(NIMTeam *)team{
    self = [super init];
    if (self) {
        _team = team;
        announceID = announce[@"id"];
        isOwner = [self.team.owner isEqualToString:[JTUserInfo shareUserInfo].userYXAccount]?YES:NO;
        [self.dataArray addObject:announce];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat offsetY = isOwner?165:0;
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-offsetY) rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview setBackgroundColor:WhiteColor];
    [self.tableview setTableHeaderView:self.tableHeadView];
    [self.tableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableview registerClass:[JTTeamAnnounceTableViewCell class] forCellReuseIdentifier:teamAnnounceIndentify];

    if (isOwner) {
        [self.view addSubview:self.tableFootView];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    }
    //服务端通过此接口记录群公告已读数
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(GroupNoticeInfoApi) parameters:@{@"group_id" : self.team.teamId, @"id" : announceID} success:^(id responseObject, ResponseState state) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)rightBtnClick:(UIButton *)sender {
    id announce = [self.dataArray firstObject];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"删除群公告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(self)weakSelf = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(DeleteAnnounceApi) parameters:@{@"group_id" : self.team.teamId,@"id" : announce[@"id"]} success:^(id responseObject, ResponseState state) {
            CCLOG(@"%@",responseObject);
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            
        }];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTTeamAnnounceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:teamAnnounceIndentify];
    [cell configCellWithAnnounce:self.dataArray[indexPath.section]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    return [tableView fd_heightForCellWithIdentifier:teamAnnounceIndentify cacheByIndexPath:indexPath configuration:^(JTTeamAnnounceTableViewCell *cell) {
        [cell configCellWithAnnounce:weakSelf.dataArray[indexPath.section]];
    }];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    sectionHeadView.backgroundColor = BlackLeverColor1;
    return sectionHeadView;
}

#pragma mark JTTeamAnnounceDelegate
- (void)announceTableFootViewClick {
    id announce = [self.dataArray firstObject];
    JTTeamAnnounceEditViewController *announceVC = [[JTTeamAnnounceEditViewController alloc] initWithNibName:@"JTTeamAnnounceEditViewController" bundle:nil];
    announceVC.team = self.team;
    announceVC.announceID = [NSString stringWithFormat:@"%@",announce[@"id"]];
    [self.navigationController pushViewController:announceVC animated:YES];
}

- (JTTeamAnnounceTableHeadView *)tableHeadView {
    if (!_tableHeadView) {
        _tableHeadView = [[JTTeamAnnounceTableHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 50)];
    }
    return _tableHeadView;
}

- (JTTeamAnnounceTableFootView *)tableFootView {
    if (!_tableFootView) {
        _tableFootView = [[JTTeamAnnounceTableFootView alloc] initWithFrame:CGRectMake(0, APP_Frame_Height-165, App_Frame_Width, 165)];
        _tableFootView.delegate = self;
    }
    return _tableFootView;
}

- (UIButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
        _rightBtn.titleLabel.font = Font(14);
        _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_rightBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}


@end
