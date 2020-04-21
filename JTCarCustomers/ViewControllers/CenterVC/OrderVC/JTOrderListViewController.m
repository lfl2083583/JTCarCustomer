//
//  JTOrderListViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/31.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTOrderTableViewCell.h"
#import "JTOrderListViewController.h"
#import "JTRescueOrderDetailViewController.h"
#import "JTStoreOrderDetailViewController.h"
#import "JTStoreEvaluateViewController.h"

@interface JTOrderListViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSIndexPath *editingIndexPath;

@end

@implementation JTOrderListViewController

- (instancetype)initWithOrderListType:(JTOrderListType)orderListType parentController:(UIViewController *)parentController {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _orderListType = orderListType;
        _parentController = parentController;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BlackLeverColor1;
    [self createTalbeView:UITableViewStyleGrouped tableFrame:CGRectMake(0, kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight*2) rowHeight:120 sectionHeaderHeight:10 sectionFooterHeight:0];
    [self.tableview setDataSource:self];
    [self.tableview registerClass:[JTOrderTableViewCell class] forCellReuseIdentifier:orderIdentifier];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderIdentifier];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;//self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.parentController.navigationController pushViewController:[[JTStoreEvaluateViewController alloc] init] animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setEditingIndexPath:indexPath];
    [self.view setNeedsLayout];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakself = self;
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [tableView setEditing:NO animated:YES];
        [weakself deleteCollection:indexPath];
    }];
    deleteRowAction.backgroundColor = BlackLeverColor1;
    return @[deleteRowAction];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(11.0)){
    //删除
    __weak typeof(self) weakself = self;
    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal title:nil handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        [tableView setEditing:NO animated:YES];
        [weakself deleteCollection:indexPath];
        completionHandler (YES);
    }];
    deleteRowAction.image = [UIImage imageNamed:@"icon_cell_delete"];
    deleteRowAction.backgroundColor = BlackLeverColor1;
    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}

- (void)deleteCollection:(NSIndexPath *)indexPath
{
    
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (self.editingIndexPath)
    {
        [self configSwipeButtons];
    }
}

- (void)configSwipeButtons
{
    if (IOS11)
    {
        // iOS 11层级 (Xcode 9编译): UITableView -> UISwipeActionPullView
        for (UIView *subview in self.tableview.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")])
            {
                [subview.subviews[0] setImage:[UIImage imageNamed:@"icon_cell_delete"] forState:UIControlStateNormal];
                [subview.subviews[0] setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        // iOS 8-10层级: UITableView -> UITableViewCell -> UITableViewCellDeleteConfirmationView
        UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subview in cell.subviews)
        {
            if ([subview isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")])
            {
                [subview.subviews[0] setImage:[UIImage imageNamed:@"icon_cell_delete"] forState:UIControlStateNormal];
                [subview.subviews[0] setTitle:@"" forState:UIControlStateNormal];
            }
        }
    }
}


@end
