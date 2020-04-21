//
//  JTAppointmentViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTAppointmentViewController.h"
#import "JTAppointmentHeaderView.h"

@interface JTAppointmentViewController ()

@property (strong, nonatomic) JTAppointmentHeaderView *headerView;
@end

@implementation JTAppointmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"预约时间"];
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) rowHeight:100 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setTableHeaderView:self.headerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (JTAppointmentHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[JTAppointmentHeaderView alloc] init];
    }
    return _headerView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
