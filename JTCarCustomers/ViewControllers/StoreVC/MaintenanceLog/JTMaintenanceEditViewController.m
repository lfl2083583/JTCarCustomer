//
//  JTMaintenanceEditViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ITDatePicker.h"
#import "JTMaintenanceEditTableHeadView.h"
#import "JTMaintenanceEditTableViewCell.h"
#import "JTMaintenanceEditViewController.h"
#import "ITContainerController.h"

@interface JTMaintenanceEditViewController () <UICollectionViewDelegate, UICollectionViewDataSource, JTMaintenanceEditDelegate, ITAlertBoxDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JTMaintenanceEditTableHeadView *headView;
@property (nonatomic, strong) UIButton *bottomBtn;
@property (nonatomic, strong) UITapGestureRecognizer *tapGuester;

@property (nonatomic, strong) NSMutableArray *seletedIDs;
@property (nonatomic, strong) NSMutableArray *seletedArray;
@property (nonatomic, assign) NSInteger maintainType;//1系统添加 2手动添加
@property (nonatomic, copy) NSString *mileage;
@property (nonatomic, copy) NSString *maintainTime;

@end


@implementation JTMaintenanceEditViewController

- (instancetype)initWithCarModel:(JTCarModel *)carModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _carModel = carModel;
    }
    return self;
}

- (instancetype)initWithCarModel:(JTCarModel *)carModel maintenanceDatas:(id)maintenanceDatas {
    self = [self initWithCarModel:carModel];
    if (self) {
        _maintenanceDatas = maintenanceDatas;
        if (maintenanceDatas) {
            _maintainType = [[maintenanceDatas objectForKey:@"maintain_type"] integerValue];
            NSArray *services = [maintenanceDatas objectForKey:@"service"];
            for (NSDictionary *dictionary in services) {
                [self.seletedIDs addObject:[dictionary objectForKey:@"service_id"]];
            }
        }
    }
    return self;
}

- (void)bottomBtnClick:(id)sender {
    if (!self.seletedArray.count) {
        [[HUDTool shareHUDTool] showHint:@"请至少选择一项保养项目" yOffset:0];
        return;
    }
    if (!self.maintainTime) {
        [[HUDTool shareHUDTool] showHint:@"请输入保养时间" yOffset:0];
        return;
    }
    if (!self.mileage || (self.mileage && [self.mileage isKindOfClass:[NSString class]] && !self.mileage.length)) {
        [[HUDTool shareHUDTool] showHint:@"请输入保养里程" yOffset:0];
        return;
    }
    NSMutableArray *contentArray = [NSMutableArray array];
    NSMutableDictionary *progem = [NSMutableDictionary dictionary];
    for (NSIndexPath *indexPath in self.seletedArray) {
        NSDictionary *dictionary = self.dataArray[indexPath.section];
        NSString *categoryID = [dictionary objectForKey:@"category_id"];
        NSArray *serviceArray = [dictionary objectForKey:@"service"];
        NSDictionary *serviceDict = [serviceArray objectAtIndex:indexPath.row];
        NSString *serviceID = [serviceDict objectForKey:@"service_id"];
        NSString *content = [NSString stringWithFormat:@"%@:%@",categoryID, serviceID];
        [contentArray addObject:content];
    }
    [progem setValue:self.mileage forKey:@"mileage"];
    [progem setValue:self.maintainTime forKey:@"maintain_time"];
    [progem setValue:[contentArray componentsJoinedByString:@","] forKey:@"services"];
    
    __weak typeof(self)weakSelf = self;
    if (!self.maintenanceDatas) {
        [progem setValue:self.carModel.carID forKey:@"car_id"];
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/maintain/Log/add") parameters:progem success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"添加成功" yOffset:0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KMaintenanceLogChangedNotification" object:nil];
        } failure:^(NSError *error) {
            
        }];
    }
    else {
        [progem setValue:[self.maintenanceDatas objectForKey:@"mlog_id"]  forKey:@"mlog_id"];
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/maintain/Log/edit") parameters:progem success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"修改成功" yOffset:0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KMaintenanceLogChangedNotification" object:nil];
        } failure:^(NSError *error) {
            
        }];
    }
}

- (void)rightBarButtonItemClick:(id)sender {
    __weak typeof(self)weakSelf = self;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"删除后，该条保养记录将不再保存和显示，确认要删除吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/maintain/Log/del") parameters:@{@"mlog_id" : [weakSelf.maintenanceDatas objectForKey:@"mlog_id"]} success:^(id responseObject, ResponseState state) {
            [[HUDTool shareHUDTool] showHint:@"删除成功" yOffset:0];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"KMaintenanceLogChangedNotification" object:nil];
        } failure:^(NSError *error) {
            
        }];
    }]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.maintainType == 1) {
        self.navigationItem.title = @"保养方案";
    }
    else if (self.maintainType == 2)
    {
        self.navigationItem.title = @"编辑保养方案";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除该记录" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
        [self.view addSubview:self.bottomBtn];
    }
    else
    {
        self.navigationItem.title = @"添加保养方案";
        [self.view addSubview:self.bottomBtn];
        
    }
    
    [self.view addSubview:self.collectionView];
    [self requestMaintainService];
}

- (void)requestMaintainService {
    __weak typeof(self)weakSelf = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(@"client/maintain/Service/get") parameters:nil success:^(id responseObject, ResponseState state) {
        if (responseObject[@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakSelf.dataArray addObjectsFromArray:responseObject[@"list"]];
            
        }
        if (weakSelf.dataArray.count && weakSelf.seletedIDs.count) {
            [weakSelf configMaintainSource];
        }
        [weakSelf.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)configMaintainSource {
    for (int i = 0; i < self.dataArray.count; i++) {
        
        NSDictionary *dictionary = self.dataArray[i];
        NSArray *serviceArray = [dictionary objectForKey:@"service"];
        
        for (int j = 0; j < serviceArray.count; j++) {
            NSDictionary *service = serviceArray[j];
            if ([self.seletedIDs containsObject:[service objectForKey:@"service_id"]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
                [self.seletedArray addObject:indexPath];
            }
        }
    }
    
    NSString *maintainTime = [self.maintenanceDatas objectForKey:@"maintain_time"];
    NSArray *array = [maintainTime componentsSeparatedByString:@"-"];
    self.maintainTime = [NSString stringWithFormat:@"%@-%@",array[0], array[1]];
    self.mileage = [NSString stringWithFormat:@"%@", [self.maintenanceDatas objectForKey:@"mileage"]];
    
    [self.headView.dateBtn setTitle:[NSString stringWithFormat:@"%@年%@月",array[0], array[1]] forState:UIControlStateNormal];
    [self.headView.mileageTF setText:self.mileage];
    self.headView.userInteractionEnabled = !(self.maintainType == 1);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTMaintenanceEditColectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:maintenanceEditColectionIdentifier forIndexPath:indexPath];
    NSDictionary *dictionary = self.dataArray[indexPath.section];
    NSArray *array = dictionary[@"service"];
    NSDictionary *service = array[indexPath.row];
    cell.titleLB.text = [service objectForKey:@"service_name"];
    if ([self.seletedArray containsObject:indexPath]) {
        cell.backgroundColor = BlueLeverColor1;
        cell.titleLB.textColor = WhiteColor;
    } else {
        cell.backgroundColor = WhiteColor;
        cell.titleLB.textColor = BlackLeverColor3;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSDictionary *dictionary = self.dataArray[section];
    NSArray *array = dictionary[@"service"];
    return array.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader)
    {
        JTMaintenanceReusableview *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:maintenanceReusableIdentifier forIndexPath:indexPath];
        reusableview = headerView;
        NSDictionary *dictionary = self.dataArray[indexPath.section];
        NSString *title = [dictionary objectForKey:@"category_name"];
        headerView.titleLB.text = title;
    }
    return reusableview;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.maintainType == 1) return;
    [self.view endEditing:YES];
    if ([self.seletedArray containsObject:indexPath]) {
        [self.seletedArray removeObject:indexPath];
    } else {
        [self.seletedArray addObject:indexPath];
    }
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

#pragma mark JTMaintenanceEditDelegate
- (void)maintenanceMileageEdite:(id)sender {
    self.collectionView.scrollEnabled = ![(UITextField *)sender isFirstResponder];
    if ([(UITextField *)sender isFirstResponder]) {
        [self.collectionView addGestureRecognizer:self.tapGuester];
    } else {
       [self.collectionView removeGestureRecognizer:self.tapGuester];
    }
    self.mileage = [(UITextField *)sender text];
}

- (void)maintenanceDateEdite:(id)sender {
    ITDatePicker *datePicker = [[ITDatePicker alloc] init];
    datePicker.delegate = self;
    datePicker.showToday = NO;
    datePicker.showOutsideDate = NO;
    datePicker.maximumDate = [Utility exchageDate:[NSDate date] format:@"YYYY.MM.dd"];
    [self presentViewController:[[ITContainerController alloc] initWithContentView:datePicker animationType:ITAnimationTypeBottom] animated:YES completion:nil];
}

#pragma mark ITAlertBoxDelegate
- (void)alertBox:(ITAlertBox *)alertBox didSelectedResult:(NSString *)dateString
{
    NSArray *array = [dateString componentsSeparatedByString:@"."];
    self.maintainTime = [NSString stringWithFormat:@"%@-%@",array[0], array[1]];
    [self.headView.dateBtn setTitle:[NSString stringWithFormat:@"%@年%@月",array[0], array[1]] forState:UIControlStateNormal];
    
}

- (void)tapRecongnizerEvent:(id)sender {
    [self.view endEditing:YES];
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.sectionInset = UIEdgeInsetsMake(10, 22, 20, 22);
        CGFloat itemWidth = (App_Frame_Width-56)/2.0;
        CGFloat itemHeight = 40;
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 12;
        layout.minimumInteritemSpacing = 12;
        layout.headerReferenceSize = CGSizeMake(App_Frame_Width, 20);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight-((self.maintainType == 1)?0:45)) collectionViewLayout:layout];
        _collectionView.backgroundColor = WhiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView setShowsVerticalScrollIndicator:NO];
        [_collectionView setContentInset:UIEdgeInsetsMake(147, 0, 0, 0)];
        [_collectionView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
        [_collectionView addSubview:self.headView];
        [_collectionView registerClass:[JTMaintenanceEditColectionViewCell class] forCellWithReuseIdentifier:maintenanceEditColectionIdentifier];
        [_collectionView registerClass:[JTMaintenanceReusableview class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:maintenanceReusableIdentifier];
    }
    return _collectionView;
}


- (JTMaintenanceEditTableHeadView *)headView {
    if (!_headView) {
        _headView = [[[NSBundle mainBundle] loadNibNamed:@"JTMaintenanceEditTableHeadView" owner:nil options:nil] firstObject];
        _headView.delegate = self;
        [_headView setX:0];
        [_headView setY:-147];
    }
    return _headView;
}

- (UIButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc] init];
        _bottomBtn.frame = CGRectMake(0, APP_Frame_Height-45, App_Frame_Width, 45);
        _bottomBtn.backgroundColor = BlueLeverColor1;
        _bottomBtn.titleLabel.font = Font(16);
        [_bottomBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottomBtn;
}

- (UITapGestureRecognizer *)tapGuester {
    if (!_tapGuester) {
        _tapGuester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecongnizerEvent:)];
        _tapGuester.numberOfTapsRequired = 1;
    }
    return _tapGuester;
}

- (NSMutableArray *)seletedArray {
    if (!_seletedArray) {
        _seletedArray = [NSMutableArray array];
    }
    return _seletedArray;
}

- (NSMutableArray *)seletedIDs {
    if (!_seletedIDs) {
        _seletedIDs = [NSMutableArray array];
    }
    return _seletedIDs;
}

@end
