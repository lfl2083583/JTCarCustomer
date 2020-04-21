//
//  JTExpressionCollectionViewController.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionCollectionViewController.h"
#import "JTChoosePhotoCollectionViewCell.h"
#import "JTExpressionCollectioBottomView.h"
#import "TZImagePickerController.h"
#import "JTExpressionTool.h"

@interface JTExpressionCollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource, JTExpressionCollectioBottomViewDelegate>
{
    BOOL isEdit;
}

@property (strong, nonatomic) UIBarButtonItem *completeItem;
@property (strong, nonatomic) UIBarButtonItem *manageItem;
@property (strong, nonatomic) JTExpressionCollectioBottomView *bottomView;
@property (strong, nonatomic) NSMutableIndexSet *indexSet;
@end

@implementation JTExpressionCollectionViewController

- (void)dealloc
{
    NSLog(@"JTExpressionCollectionViewController 释放");
}

- (void)leftClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)manageClick:(id)sender
{
    self.navigationItem.rightBarButtonItem = self.completeItem;
    isEdit = YES;
    [self.indexSet removeAllIndexes];
    [self.collectionview reloadData];
    [self.collectionview.mj_header setHidden:YES];
    [self.bottomView show];
    [self.collectionview setHeight:APP_Frame_Height-self.bottomView.height];
}

- (void)completeClick:(id)sender
{
    self.navigationItem.rightBarButtonItem = self.manageItem;
    isEdit = NO;
    [self.indexSet removeAllIndexes];
    [self.collectionview reloadData];
    [self.collectionview.mj_header setHidden:NO];
    [self.bottomView hide];
    [self.collectionview setHeight:APP_Frame_Height];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"添加的表情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(leftClick:)];
    self.manageItem = [[UIBarButtonItem alloc] initWithTitle:@"整理" style:UIBarButtonItemStylePlain target:self action:@selector(manageClick:)];
    self.completeItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completeClick:)];
    self.navigationItem.rightBarButtonItem = self.manageItem;
    
    UICollectionViewFlowLayout *_layout = [UICollectionViewFlowLayout new];
    CGFloat itemWidth = floor((CGFloat)([[UIScreen mainScreen] bounds].size.width/4.0));
    CGFloat itemHeight = itemWidth;
    _layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    _layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _layout.minimumLineSpacing = 0;
    _layout.minimumInteritemSpacing = 0;
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, App_Frame_Width, APP_Frame_Height-kStatusBarHeight-kTopBarHeight) collectionViewLayout:_layout];
    self.collectionview.dataSource = self;
    self.collectionview.delegate = self;
    self.collectionview.backgroundColor = BlackLeverColor1;
    [self.collectionview registerClass:[JTChoosePhotoCollectionViewCell class] forCellWithReuseIdentifier:choosePhotoIdentifier];
    [self.view addSubview:self.collectionview];
    [self setShowCollectionRefreshHeader:YES];
    [self.collectionview.mj_header beginRefreshing];
    [self.view addSubview:self.bottomView];
}

- (void)getListData:(void (^)(void))requestComplete
{
    __weak typeof(self) weakself = self;
    [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EmoticonFavoriteListApi) parameters:nil success:^(id responseObject, ResponseState state) {
        if (weakself.page == 1) {
            [weakself.dataArray removeAllObjects];
        }
        [weakself handleResult:responseObject];
        [super getListData:requestComplete];
    } failure:^(NSError *error) {
        [super getListData:requestComplete];
    }];
}

- (void)handleResult:(id)result
{
    if ([result objectForKey:@"list"] && [result[@"list"] isKindOfClass:[NSArray class]]) {
        [result[@"list"] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            if ([obj1[@"sort"] integerValue] > [obj1[@"sort"] integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            if ([obj1[@"sort"] integerValue] < [obj1[@"sort"] integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        [self.dataArray addObjectsFromArray:result[@"list"]];
        [[JTExpressionTool sharedManager] reloadCollectionExpressions:self.dataArray];
        [[NSNotificationCenter defaultCenter] postNotificationName:kResetInputExpressionNotification object:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count + !isEdit;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JTChoosePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:choosePhotoIdentifier forIndexPath:indexPath];
    cell.backgroundColor = WhiteColor;
    if (indexPath.row == self.dataArray.count) {
        cell.markIcon.hidden = YES;
        cell.photo.image = [UIImage imageNamed:@"icon_addCollectionEmoticon"];
    }
    else
    {
        if (isEdit) {
            cell.markIcon.hidden = NO;
            cell.markIcon.image = [UIImage imageNamed:([self.indexSet containsIndex:indexPath.row])?@"icon_accessory_selected":@"icon_accessory_normal"];
        }
        else
        {
            cell.markIcon.hidden = YES;
        }
        NSString *urlString = [self.dataArray[indexPath.row][@"image"] avatarHandleWithSquare:cell.photo.width*2];
        [cell.photo sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.dataArray.count) {
        __weak typeof(self) weakself = self;
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
        imagePickerVc.navigationBar.barTintColor = WhiteColor;
        imagePickerVc.navigationBar.tintColor = BlackLeverColor5;
        imagePickerVc.navigationBar.titleTextAttributes = @{NSFontAttributeName: Font(18), NSForegroundColorAttributeName: BlackLeverColor6};
        imagePickerVc.barItemTextColor = BlackLeverColor3;
        imagePickerVc.barItemTextFont = Font(14);
        
        imagePickerVc.allowPickingVideo = NO;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [[HttpRequestTool sharedInstance] uploadWithFileNames:nil uploadFileArr:photos success:^(id responseObject) {

                NSMutableArray *resources = [NSMutableArray array];
                for (NSInteger index = 0; index < [responseObject count]; index ++) {
                    NSString *url = [responseObject objectAtIndex:index];
                    UIImage *photo = [photos objectAtIndex:index];
                    [resources addObject:@{@"name": @"", @"image": url, @"thumb": [url avatarHandleWithSquare:200], @"md5": [photo MD5String], @"width": [NSString stringWithFormat:@"%.2f", photo.size.width], @"height": [NSString stringWithFormat:@"%.2f", photo.size.height]}];
                }
                [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EmoticonAddFavoriteApi) parameters:@{@"pic_list": [resources mj_JSONString]} success:^(id responseObject, ResponseState state) {
                    if ([responseObject objectForKey:@"list"] && [responseObject[@"list"] isKindOfClass:[NSArray class]]) {
                        [[HUDTool shareHUDTool] showHint:@"添加成功"];
                        [weakself handleResult:responseObject];
                        [weakself.collectionview reloadData];
                    }
                } failure:^(NSError *error) {
                    
                }];
            } failure:^(NSError *error) {

            }];
        }];
        [weakself presentViewController:imagePickerVc animated:YES completion:nil];
    }
    else
    {
        if (isEdit) {
            if ([self.indexSet containsIndex:indexPath.row]) {
                [self.indexSet removeIndex:indexPath.row];
            }
            else
            {
                [self.indexSet addIndex:indexPath.row];
            }
            [self.collectionview reloadData];
        }
    }
}

- (void)expressionCollectioBottomView:(JTExpressionCollectioBottomView *)expressionCollectioBottomView expressionCollectioOperationType:(JTExpressionCollectioOperationType)expressionCollectioOperationType
{
    if (self.indexSet.count > 0) {
        if (expressionCollectioOperationType == JTExpressionCollectioOperationTypePreInduced) {
            NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
            NSArray *reversedArray = [[[array objectsAtIndexes:self.indexSet] reverseObjectEnumerator] allObjects];
            [array removeObjectsAtIndexes:self.indexSet];
            [array insertObjects:reversedArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, reversedArray.count)]];
            NSMutableArray *sortArr = [NSMutableArray array];
            for (NSInteger index = 0; index < array.count; index ++) {
                [sortArr addObject:@{@"id": [[array objectAtIndex:index] objectForKey:@"id"], @"sort": [NSNumber numberWithInteger:index]}];
            }
            [[HUDTool shareHUDTool] showHint:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
            __weak typeof(self) weakself = self;
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EmoticonSortFavoriteApi) parameters:@{@"sort": [sortArr mj_JSONString]} success:^(id responseObject, ResponseState state) {
                
                [[HUDTool shareHUDTool] hideHUD];
                [weakself.indexSet removeAllIndexes];
                [weakself.dataArray removeAllObjects];
                [weakself.dataArray addObjectsFromArray:array];
                [[JTExpressionTool sharedManager] reloadCollectionExpressions:weakself.dataArray];
                [[NSNotificationCenter defaultCenter] postNotificationName:kResetInputExpressionNotification object:nil];
                [weakself.collectionview reloadData];
            } failure:^(NSError *error) {
                
            }];
        }
        else if (expressionCollectioOperationType == JTExpressionCollectioOperationTypeDelete) {
            NSMutableArray *ids = [NSMutableArray array];
            NSArray *deleteArray = [self.dataArray objectsAtIndexes:self.indexSet];
            for (NSInteger index = 0; index < deleteArray.count; index ++) {
                [ids addObject:[[deleteArray objectAtIndex:index] objectForKey:@"id"]];
            }
            [[HUDTool shareHUDTool] showHint:@"" yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
            __weak typeof(self) weakself = self;
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(EmoticonRemoveFavoriteApi) parameters:@{@"ids": [ids componentsJoinedByString:@","]} success:^(id responseObject, ResponseState state) {
                [[HUDTool shareHUDTool] hideHUD];
                [weakself.dataArray removeObjectsAtIndexes:weakself.indexSet];
                [weakself.indexSet removeAllIndexes];
                [[JTExpressionTool sharedManager] reloadCollectionExpressions:weakself.dataArray];
                [[NSNotificationCenter defaultCenter] postNotificationName:kResetInputExpressionNotification object:nil];
                [weakself.collectionview reloadData];
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

- (JTExpressionCollectioBottomView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[JTExpressionCollectioBottomView alloc] initWithDelegate:self];
    }
    return _bottomView;
}

- (NSMutableIndexSet *)indexSet
{
    if (!_indexSet) {
        _indexSet = [NSMutableIndexSet indexSet];
    }
    return _indexSet;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
