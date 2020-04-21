//
//  JTCarModelViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarModelViewController.h"
#import "ZTTableViewHeaderFooterView.h"

@interface JTCarModelViewController () <UITableViewDataSource>

@end

@implementation JTCarModelViewController

- (instancetype)initWithDelegate:(id<JTCarModelViewControllerDelegate>)delegate
{
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"选择年款配置"];
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigation rowHeight:44 sectionHeaderHeight:25 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[ZTTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray[section] objectForKey:@"spec_list"] count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZTTableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterIdentifier];
    footer.promptLB.text = [self.dataArray[section] objectForKey:@"years_str"];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(14);
        cell.textLabel.textColor = BlackLeverColor6;
    }
    NSDictionary *source = [[self.dataArray[indexPath.section] objectForKey:@"spec_list"] objectAtIndex:indexPath.row];
    [cell.textLabel setText:source[@"spec_name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *source = [[self.dataArray[indexPath.section] objectForKey:@"spec_list"] objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(carModelViewController:didSelectAtSource:)]) {
        [_delegate carModelViewController:self didSelectAtSource:source];
    }
    UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 3)];
    [self.navigationController popToViewController:viewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
