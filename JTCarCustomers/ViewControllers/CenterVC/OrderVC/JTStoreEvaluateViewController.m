//
//  JTStoreEvaluateViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTObtainPhotoTool.h"
#import "JTRescueEvaluateTableFootView.h"
#import "JTStoreEvaluateTableViewCell.h"
#import "JTStoreEvaluateViewController.h"

@interface JTStoreEvaluateViewController () <UITableViewDataSource, JTStoreEvaluateTableViewCellDelegate, JTRescueEvaluateTableFootViewDelegate>

@property (nonatomic, strong) JTRescueEvaluateTableFootView *tableFootView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, assign) CGFloat environmentScore;
@property (nonatomic, assign) CGFloat abilityScore;
@property (nonatomic, assign) CGFloat serviceScore;
@property (nonatomic, assign) BOOL isAnonymous;

@end

@implementation JTStoreEvaluateViewController

- (void)bottomBtnClick:(UIButton *)sender {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"评价"];
    [self createTalbeView:UITableViewStylePlain tableHeightType:JTTableHeightTypeNavigationAndTabbar rowHeight:44];
    [self.tableview setDataSource:self];
    [self.tableview setBackgroundColor:WhiteColor];
    [self.tableview setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    [self.tableview setTableFooterView:self.tableFootView];
    [self.tableview registerClass:[JTStoreEvaluateTableViewCell class] forCellReuseIdentifier:storeEvaluateIdentifier];
    [self.view addSubview:self.bottomBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JTStoreEvaluateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storeEvaluateIdentifier];
    cell.delegate = self;
    cell.photoArray = self.photos;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [JTStoreEvaluateTableViewCell getCellHeightWithPhotos:self.photos];
}

#pragma mark JTStoreEvaluateTableViewCellDelegate
- (void)storeEvaluateTableViewCellAddPhoto
{
    __weak typeof(self)weakSelf = self;
    [[ZTObtainPhotoTool shareObtainPhotoTool] show:self success:^(UIImage *image) {
        [weakSelf.photos addObject:image];
        [weakSelf.tableview reloadData];
    } cancel:^{
        
    }];
}

- (void)storeEvaluateTableViewCellDeletePhoto:(NSInteger)index
{
    if (self.photos) {
        [self.photos removeObjectAtIndex:index];
        [self.tableview reloadData];
    }
}

- (void)storeEvaluateTableViewCellStarEvaluate:(JTStoreStarType)starType score:(CGFloat)score
{
    if (starType == JTStoreStarTypeEnvironment) {
        self.environmentScore = score;
    }
    else if (starType == JTStoreStarTypeAbility) {
        self.abilityScore = score;
    }
    else {
        self.serviceScore = score;
    }
}

#pragma mark JTRescueEvaluateTableFootViewDelegate
- (void)evaluateTableFootViewCheckBoxIsSeleted:(BOOL)flag{
    self.isAnonymous = flag;
}

- (JTRescueEvaluateTableFootView *)tableFootView {
    if (!_tableFootView) {
        _tableFootView = [[JTRescueEvaluateTableFootView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 90)];
        _tableFootView.delegate = self;
    }
    return _tableFootView;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.frame = CGRectMake(0, APP_Frame_Height-45, App_Frame_Width, 45);
        _bottomBtn.backgroundColor = BlueLeverColor1;
        _bottomBtn.titleLabel.font = Font(16);
        [_bottomBtn setTitle:@"提交评价" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}


@end
