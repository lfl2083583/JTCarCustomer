//
//  JTBonusDetailViewController.m
//  JTSocial
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 JTTeam. All rights reserved.
//
#import "JTBonusContainerViewController.h"
#import "JTBonusDetailViewController.h"
#import "JTNavigationBar.h"
#import "JTBonusDetailHeaderView.h"
#import "JTBonusDetailTableViewCell.h"

#import "JTWalletViewController.h"
#import "JTCardViewController.h"

@implementation JTBonusDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"sendUserAvatar"         :  @"from_avatar",
             @"sendUserName"           :  @"from_nick",
             @"sendUserID"             :  @"from_uid",
             @"bonusID"            :  @"id",
             @"bonusTitle"         :  @"title",
             @"bonusType"          :  @"type",
             @"bonusCount"         :  @"num",
             @"bonusMoney"         :  @"amount",
             @"bonusRobCount"      :  @"robcount",
             @"bonusRobMoney"      :  @"robmoney",
             @"bonusRobTime"       :  @"rob_time",
             @"robMoney"           :  @"self_account",
             @"isGrabbed"              :  @"is_rob",
             @"isSender"               :  @"is_send",
             @"isOverTime"             :  @"is_time_out"
             };
}

- (NSString *)timeTitle
{
    if (!_timeTitle) {
        if (self.bonusRobTime < 60) {
            _timeTitle = [NSString stringWithFormat:@"%ld秒", self.bonusRobTime];
        }
        else if (self.bonusRobTime < 3600) {
            _timeTitle = [NSString stringWithFormat:@"%ld分钟", self.bonusRobTime/60];
        }
        else
        {
            _timeTitle = [NSString stringWithFormat:@"%ld小时", self.bonusRobTime/3600];
        }
    }
    return _timeTitle;
}

@end

@implementation JTBonusListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"receiveTime"     :  @"earn_time",
             @"isMax"           :  @"max",
             @"userID"          :  @"fid",
             @"userAvatar"      :  @"avatar",
             @"userName"        :  @"nick_name",
             @"money"           :  @"amount",
             @"senderID"        :  @"uid",
             };
}

@end


@interface JTBonusDetailViewController () <JTNavigationBarDelegate, JTBonusDetailHeaderViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) JTBonusDetailNavigationBar *navigationBar;
@property (strong, nonatomic) JTBonusDetailHeaderView *headerView;
@property (strong, nonatomic) UIView *footerView;

@end

@implementation JTBonusDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [super viewWillDisappear:animated];
}

- (instancetype)initWithBonusDetailModel:(JTBonusDetailModel *)bonusDetailModel bonusList:(NSArray *)bonusList 
{
    self = [super init];
    if (self) {
        _bonusDetailModel = bonusDetailModel;
        [self.dataArray addObjectsFromArray:bonusList];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTalbeView:UITableViewStylePlain rowHeight:60];
    [self.tableview setTableHeaderView:self.headerView];
    if (self.bonusDetailModel.isSender && self.bonusDetailModel.bonusCount != self.bonusDetailModel.bonusRobCount) {
        [self.tableview setTableFooterView:self.footerView];
    }
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTBonusDetailTableViewCell class] forCellReuseIdentifier:bonusDetailIdentifier];
    [self.view addSubview:self.navigationBar];
}

- (void)navigationBarToLeft:(id)navigationBar
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationBarToRight:(id)navigationBar
{
    [self.navigationController pushViewController:[[JTBonusContainerViewController alloc] init] animated:YES];
}

- (void)lookWalletInBonusDetailHeaderView:(id)bonusDetailHeaderView
{
    [self.navigationController pushViewController:[[JTWalletViewController alloc] init] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row == 0) ? 25 : 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((self.bonusDetailModel.bonusType == JTBonusTypeNormal || self.bonusDetailModel.bonusType == JTBonusTypeTeamAverage) && self.bonusDetailModel.isGrabbed) ? 0 : (self.dataArray.count + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *cellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.font = Font(14);
            cell.textLabel.textColor = BlackLeverColor3;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.bonusDetailModel.bonusType == 1) {
            if (self.bonusDetailModel.bonusCount == self.bonusDetailModel.bonusRobCount) {
                cell.textLabel.text = [NSString stringWithFormat:@"1个红包共%.2f唐人币", self.bonusDetailModel.bonusMoney];
            }
            else
            {
                if (self.bonusDetailModel.isOverTime) {
                    cell.textLabel.text = [NSString stringWithFormat:@"该红包已过期。已领取0/1个，共0.00/%.2f唐人币", self.bonusDetailModel.bonusMoney];
                }
                else
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"红包金额%.2f唐人币，等待对方领取", self.bonusDetailModel.bonusMoney];
                }
            }
        }
        else
        {
            if (self.bonusDetailModel.bonusCount == self.bonusDetailModel.bonusRobCount) {
                cell.textLabel.text = [NSString stringWithFormat:@"%ld个红包共%.2f唐人币，%@被抢光", self.bonusDetailModel.bonusCount, self.bonusDetailModel.bonusMoney, self.bonusDetailModel.timeTitle];
            }
            else if (self.bonusDetailModel.bonusRobCount == 0) {
                if (self.bonusDetailModel.isOverTime) {
                    cell.textLabel.text = [NSString stringWithFormat:@"该红包已过期。红包金额%.2f唐人币，0/%ld领取", self.bonusDetailModel.bonusMoney, self.bonusDetailModel.bonusCount];
                }
                else
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"红包金额%.2f唐人币，0/%ld领取", self.bonusDetailModel.bonusMoney, self.bonusDetailModel.bonusCount];
                }
            }
            else
            {
                if (self.bonusDetailModel.isSender) {
                    if (self.bonusDetailModel.isOverTime) {
                        cell.textLabel.text = [NSString stringWithFormat:@"该红包已过期。已领取%ld/%ld个，共%.2f/%.2f唐人币", self.bonusDetailModel.bonusRobCount, self.bonusDetailModel.bonusCount, self.bonusDetailModel.bonusRobMoney, self.bonusDetailModel.bonusMoney];
                    }
                    else
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"已领取%ld/%ld个，共%.2f/%.2f唐人币", self.bonusDetailModel.bonusRobCount, self.bonusDetailModel.bonusCount, self.bonusDetailModel.bonusRobMoney, self.bonusDetailModel.bonusMoney];
                    }
                }
                else
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"已领取%ld/%ld个", self.bonusDetailModel.bonusRobCount, self.bonusDetailModel.bonusCount];
                }
            }
        }
        return cell;
    }
    else
    {
        JTBonusDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:bonusDetailIdentifier];
        JTBonusListModel *model = [self.dataArray objectAtIndex:indexPath.row-1];
        if (model.userAvatar) {
            [cell.avatarImageView setAvatarByUrlString:[model.userAvatar avatarHandleWithSquare:80] defaultImage:DefaultSmallAvatar];
        }
        cell.titleLB.text = model.userName;
        cell.timeLB.text = [Utility showTime:[model.receiveTime integerValue] showDetail:YES];
        cell.moneyLB.text = [NSString stringWithFormat:@"%@唐人币", model.money];
        if (model.isMax) {
            cell.detailLB.text = @"手气最佳";
            cell.detailLB.textColor = YellowColor;
        }
        else
        {
            cell.detailLB.text = @"";
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        JTBonusListModel *model = [self.dataArray objectAtIndex:indexPath.row-1];
        [self.navigationController pushViewController:[[JTCardViewController alloc] initWithUserID:model.userID] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (JTBonusDetailNavigationBar *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[JTBonusDetailNavigationBar alloc] init];
        _navigationBar.frame = CGRectMake(0, 0, App_Frame_Width, kStatusBarHeight+kTopBarHeight);
        _navigationBar.delegate = self;
        _navigationBar.backgroundColor = RedLeverColor1;
        BOOL showRightBar = NO;
        for (UIViewController *viewController in self.navigationController.childViewControllers) {
            if ([viewController isKindOfClass:[JTBonusContainerViewController class]]) {
                showRightBar = YES;
                break;
            }
        }
        _navigationBar.rightBT.hidden = showRightBar;
    }
    return _navigationBar;
}

- (JTBonusDetailHeaderView *)headerView
{
    if (!_headerView) {
        NSString *xibName = self.bonusDetailModel.isGrabbed?@"JTBonusRodDetailHeaderView":@"JTBonusDetailHeaderView";
        _headerView = [[[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil] lastObject];
        [_headerView configWithBonusDetailHeaderView:self.bonusDetailModel.sendUserAvatar
                                        sendUserName:self.bonusDetailModel.sendUserName
                                          bonusTitle:self.bonusDetailModel.bonusTitle
                                           bonusType:self.bonusDetailModel.bonusType
                                       bonusRobMoney:self.bonusDetailModel.robMoney
         ];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 80)];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(0, 50, App_Frame_Width, 30);
        label.text = @"未领取的红包，将于24小时后发起退款";
        label.font = Font(14);
        label.textColor = BlackLeverColor3;
        label.textAlignment = NSTextAlignmentCenter;
        
        [_footerView addSubview:label];
    }
    return _footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
