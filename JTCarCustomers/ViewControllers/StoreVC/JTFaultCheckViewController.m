//
//  JTFaultCheckViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTFaultCheckViewController.h"
#import "JTImageCollectionViewCell.h"
#import "JTFaultSearchViewController.h"
#import "NormalWebViewController.h"
#import "JTTalentListViewController.h"

@interface JTFaultCheckViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JTFaultCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"故障自查"];
    [self.contentView addSubview:self.collectionView];
    [self.collectionView registerClass:[JTImageCollectionViewCell class] forCellWithReuseIdentifier:imageCollectionIndentifier];
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(getCategoryListApi) parameters:nil success:^(id responseObject, ResponseState state) {
        if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
            [weakself.dataArray addObjectsFromArray:responseObject[@"list"]];
        }
        [weakself.collectionView setHeight:ceil(weakself.dataArray.count/4)*81];
        [weakself.collectionView reloadData];
        [weakself.contentView setHeight:weakself.collectionView.bottom];
        [weakself.bottomView setTop:weakself.contentView.bottom];
        [weakself.scrollview setContentSize:CGSizeMake(0, weakself.bottomView.bottom)];
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)searchClick:(id)sender {
    [self.navigationController pushViewController:[[JTFaultSearchViewController alloc] init] animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageCollectionIndentifier forIndexPath:indexPath];
    NSDictionary *sourceDic = [self.dataArray objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:sourceDic[@"icon"]]];
    [cell.titleLB setText:sourceDic[@"c_name"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *navTitle = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"c_name"];;
    NSString *urlString = [[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"h5_url"];
    [self.navigationController pushViewController:[[NormalWebViewController alloc] initWithNavTitle:navTitle urlString:urlString] animated:YES];
}

- (IBAction)contactClick:(id)sender {
    [self.navigationController pushViewController:[[JTTalentListViewController alloc] init] animated:YES];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *_layout = [UICollectionViewFlowLayout new];
        CGFloat itemWidth = floor((CGFloat)([[UIScreen mainScreen] bounds].size.width/4.0));
        _layout.itemSize = CGSizeMake(itemWidth, 81);
        _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 107, App_Frame_Width, 0) collectionViewLayout:_layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
