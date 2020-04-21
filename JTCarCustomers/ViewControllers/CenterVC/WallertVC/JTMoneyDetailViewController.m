//
//  JTMoneyDetailViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMoneyDetailViewController.h"

@interface JTMoneyDetailViewController () <UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLB;

@end

@implementation JTMoneyDetailViewController

- (instancetype)initWithSource:(id)source {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _source = source;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.titleLB];
    [self createTalbeView:UITableViewStylePlain tableFrame:CGRectMake(0, CGRectGetMaxY(self.titleLB.frame), App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-40) rowHeight:47 sectionHeaderHeight:0 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *normalIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalIdentifier];
        cell.textLabel.textColor = BlackLeverColor3;
        cell.textLabel.font = Font(16);
        cell.detailTextLabel.font = Font(16);
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    switch (indexPath.row) {
        case 0:
        {
            cell.detailTextLabel.textColor = BlueLeverColor1;
            cell.textLabel.text = @"出账金额（溜车币）";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f", [self.source[@"number"] floatValue]*[self.source[@"incType"] floatValue]];
        }
            break;
        case 1:
        {
            cell.detailTextLabel.textColor = BlackLeverColor6;
            cell.textLabel.text = @"类型";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [self.source[@"incType"] floatValue]>0?@"收入":@"支出"];
            
        }
            break;
        case 2:
        {
            cell.detailTextLabel.textColor = BlackLeverColor5;
            cell.textLabel.text = @"时间";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.source[@"create_time"]];
        }
            break;
        case 3:
        {
            cell.detailTextLabel.textColor = BlackLeverColor5;
            cell.textLabel.text = @"交易单号";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.source[@"no"]];
        }
            break;
        default:
            break;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(15, kTopBarHeight+kStatusBarHeight, App_Frame_Width-15, 40)];
        _titleLB.font = Font(24);
        _titleLB.text = self.source[@"log_name"];
    }
    return _titleLB;
}

@end
