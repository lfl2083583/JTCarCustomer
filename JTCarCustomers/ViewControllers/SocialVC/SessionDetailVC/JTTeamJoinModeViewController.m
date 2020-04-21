//
//  JTTeamJoinModeViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamJoinModeViewController.h"

@interface JTTeamJoinModeViewController () <UITableViewDataSource>

@property (strong, nonatomic) UIImageView *accessoryView;
@end

@implementation JTTeamJoinModeViewController

- (instancetype)initWithSession:(NIMSession *)session powerModel:(JTTeamPowerModel *)powerModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _session = session;
        _powerModel = powerModel;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamMembersUpdatedNotification object:nil];
}

- (void)updateTableViewNotification:(NSNotification *)notification
{
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"加群设置"];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewNotification:) name:kJTTeamMembersUpdatedNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(16);
        cell.textLabel.textColor = BlackLeverColor5;
        cell.detailTextLabel.font = Font(14);
        cell.detailTextLabel.textColor = BlackLeverColor3;
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"需要群主审核";
        if (self.powerModel.joinTeamType == 2) {
            [cell addSubview:self.accessoryView];
        }
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"允许任何人加群";
        if (self.powerModel.joinTeamType == 1) {
            [cell addSubview:self.accessoryView];
        }
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"不允许任何人加群";
        if (self.powerModel.joinTeamType == 0) {
            [cell addSubview:self.accessoryView];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *invite = (indexPath.row == 0) ? @"2" : ((indexPath.row == 1) ? @"1" : @"0");
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(SetJoinGroupModeApi) parameters:@{@"group_id": self.session.sessionId, @"invite": invite} success:^(id responseObject, ResponseState state) {
        [[HUDTool shareHUDTool] showHint:@"设置入群审核方式成功"];
    } failure:^(NSError *error) {
    }];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIImageView *)accessoryView
{
    if (!_accessoryView) {
        _accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_accessory_selected"]];
        _accessoryView.frame = CGRectMake(App_Frame_Width-37, 11, 22, 22);
    }
    return _accessoryView;
}
@end
