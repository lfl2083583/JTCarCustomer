//
//  JTSearchStrangerViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/14.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTWordItem.h"
#import "JTSearchStrangerViewController.h"

@implementation JTSearchStrangerHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLabel];
        [self addSubview:self.segmentalView];
        self.backgroundColor = WhiteColor;
    }
    return self;
}

- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 0, self.bounds.size.width - 22 , 40)];
        _leftLabel.font = Font(24);
    }
    return _leftLabel;
}

- (JTSegmentalView *)segmentalView {
    if (!_segmentalView) {
        _segmentalView = [[JTSegmentalView alloc] initWithFrame:CGRectMake(29, CGRectGetMaxY(self.leftLabel.frame) + 37, self.bounds.size.width - 58, 60) titles:@[@"女", @"男", @"不限"]];
    }
    return _segmentalView;
}

@end

static NSString *searchStrangerId = @"JTSearchStrangerCell";

@interface JTSearchStrangerViewController () <UITableViewDataSource>

@property (nonatomic, strong) JTSearchStrangerHeadView *headView;

@end

@implementation JTSearchStrangerViewController

- (JTSearchStrangerHeadView *)headView {
    if (!_headView) {
        _headView = [[JTSearchStrangerHeadView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 137)];
        _headView.leftLabel.text = @"按条件查找陌生人";
    }
    return _headView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createTalbeView:UITableViewStyleGrouped tableHeightType:JTTableHeightTypeNavigation rowHeight:70 sectionHeaderHeight:20 sectionFooterHeight:0];
    self.tableview.dataSource = self;
    self.tableview.tableHeaderView = self.headView;
    self.view.backgroundColor = WhiteColor;
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.tableHeaderView = self.headView;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self setupComponent];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"查找" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)rightItemClick:(UIButton *)sender {
    
}

- (void)setupComponent {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = @"   认证车辆";
    item.subTitle = @"不限";
    [self.dataArray addObject:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchStrangerId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:searchStrangerId];
        cell.textLabel.font = Font(18);
        cell.textLabel.textColor = BlackLeverColor5;
        cell.detailTextLabel.font = Font(18);
        cell.detailTextLabel.textColor = BlackLeverColor3;
        cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(20, 69.5, self.view.bounds.size.width - 20, 0.5)];
        bottomView.backgroundColor = BlackLeverColor2;
        [cell.contentView addSubview:bottomView];
    }
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.subTitle;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
