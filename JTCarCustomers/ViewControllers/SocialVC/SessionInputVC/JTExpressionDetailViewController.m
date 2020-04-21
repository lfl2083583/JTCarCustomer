//
//  JTExpressionDetailViewController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionDetailViewController.h"
#import "JTPhotoCollectionViewCell.h"
#import "JTExpressionDetailViewController.h"
#import "JTExpressionTool.h"

static NSString *expressionDetailHeaderIndetifier = @"JTExpressionDetailCollectionHeaderView";

@implementation JTExpressionDetailCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
        [self setViewAtuoLayout];
        self.height = 75;
    }
    return self;
}

- (UILabel *)nameLB
{
    if (!_nameLB) {
        _nameLB = [[UILabel alloc] init];
        _nameLB.font = Font(18);
        _nameLB.textColor = BlackLeverColor6;
    }
    return _nameLB;
}

- (UILabel *)detailLB
{
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = Font(14);
        _detailLB.textColor = BlackLeverColor3;
    }
    return _detailLB;
}

- (UIButton *)downloadBT
{
    if (!_downloadBT) {
        _downloadBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _downloadBT.titleLabel.font = Font(15);
        _downloadBT.layer.cornerRadius = 15;
        [_downloadBT addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downloadBT;
}

- (void)downloadClick:(id)sender
{
    if (self.didSelectDownloadBlock) {
        self.didSelectDownloadBlock();
    }
}

- (void)initSubview
{
    [self addSubview:self.nameLB];
    [self addSubview:self.detailLB];
    [self addSubview:self.downloadBT];
}

- (void)setViewAtuoLayout
{
    __weak typeof(self) weakself = self;
    
    [self.downloadBT mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(@25);
        make.right.equalTo(@-10);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
    
    [self.nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@15);
        make.left.equalTo(@10);
        make.height.equalTo(@25);
        make.right.equalTo(weakself.downloadBT.mas_left).with.offset(-15);
    }];
    
    [self.detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(@40);
        make.left.equalTo(@10);
        make.height.equalTo(@25);
        make.right.equalTo(weakself.downloadBT.mas_left).with.offset(-15);
    }];
}

- (void)setSourceDic:(NSMutableDictionary *)sourceDic
{
    if (sourceDic && [sourceDic isKindOfClass:[NSDictionary class]]) {
        _sourceDic = sourceDic;
        
        self.nameLB.text = sourceDic[@"name"];
        self.detailLB.text = sourceDic[@"description"];
        
        BOOL is_download = [[sourceDic objectForKey:@"is_download"] boolValue];
        if (is_download) {

            [self.downloadBT setUserInteractionEnabled:NO];
            [self.downloadBT setTitle:@"已获取" forState:UIControlStateNormal];
            [self.downloadBT setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.downloadBT setBackgroundColor:BlackLeverColor3];
        }
        else
        {
            [self.downloadBT setUserInteractionEnabled:YES];
            [self.downloadBT setTitle:@"获取" forState:UIControlStateNormal];
            [self.downloadBT setTitleColor:WhiteColor forState:UIControlStateNormal];
            [self.downloadBT setBackgroundColor:BlueLeverColor1];
        }
    }
}

@end

@interface JTExpressionDetailViewController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (strong, nonatomic) UICollectionViewFlowLayout *collectionLayout;

@end

@implementation JTExpressionDetailViewController

- (instancetype)initWithSourceDic:(NSDictionary *)sourceDic
{
    self = [super init];
    if (self) {
        _sourceDic = [sourceDic mutableCopy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    self.navigationItem.title = [self.sourceDic objectForKey:@"name"];
    UICollectionViewFlowLayout *_layout = [UICollectionViewFlowLayout new];
    CGFloat itemWidth = floorf((App_Frame_Width - 25) / 4.0);
    CGFloat itemHeight = itemWidth;
    _layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    _layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _layout.minimumLineSpacing = 5;
    _layout.minimumInteritemSpacing = 5;
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _layout.headerReferenceSize = CGSizeMake(App_Frame_Width, 75);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) collectionViewLayout:_layout];
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    [self.collectionview setShowsHorizontalScrollIndicator:NO];
    [self.collectionview setShowsVerticalScrollIndicator:NO];
    [self.collectionview registerClass:[JTPhotoCollectionViewCell class] forCellWithReuseIdentifier:photoIdentifier];
    [self.collectionview registerClass:[JTExpressionDetailCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:expressionDetailHeaderIndetifier];
    [self.view addSubview:self.collectionview];
    
    __weak typeof (self)weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EmoticonsDetailApi) parameters:@{@"emoti_id": self.sourceDic[@"id"]} success:^(id responseObject, ResponseState state) {
        [weakself.dataArray addObjectsFromArray:responseObject[@"list"]];
        [weakself.collectionview reloadData];

    } failure:^(NSError *error) {

    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    JTExpressionDetailCollectionHeaderView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:expressionDetailHeaderIndetifier forIndexPath:indexPath];
    reusableView.sourceDic = self.sourceDic;
    __weak typeof(self) weakself = self;
    reusableView.didSelectDownloadBlock = ^{
        [weakself downloadExpression];
    };
    return reusableView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoIdentifier forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row][@"img_static"]]];
    return cell;
}

#pragma mark - JTExpressionDetailCollectionHeaderViewDelegate
- (void)downloadExpression
{
    __weak typeof(self) weakself = self;
    [[HUDTool shareHUDTool] showHint:@"下载中..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(DownloadApi) parameters:@{@"emoti_id": self.sourceDic[@"id"]} success:^(id responseObject, ResponseState state) {
        
        [weakself.sourceDic setObject:responseObject[@"list"] forKey:@"list"];
        [weakself.sourceDic setObject:@"0" forKey:@"sort"];
        [[JTExpressionTool sharedManager] addSingleModel:weakself.sourceDic success:^{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kModifyExpressionNotification object:@{@"id": weakself.sourceDic[@"id"], @"is_download": @"1"}];
            [weakself.sourceDic setObject:@"1" forKey:@"is_download"];
            [weakself.collectionview reloadData];
            [[HUDTool shareHUDTool] showHint:@"下载成功" yOffset:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:kResetInputExpressionNotification object:nil];
            
        } failure:^{
            [[HUDTool shareHUDTool] showHint:@"下载失败" yOffset:0];
        }];
        
    } failure:^(NSError *error) {
        [[HUDTool shareHUDTool] showHint:@"下载失败" yOffset:0];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
