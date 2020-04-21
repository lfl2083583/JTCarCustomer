//
//  JTInputAlbumContainerView.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputAlbumContainerView.h"
#import "JTImagePickerController.h"
#import "JTInputChooseVideoCollectionViewCell.h"
#import "JTInputChoosePhotoCollectionViewCell.h"
#import "JTInputGlobal.h"

@interface JTInputAlbumContainerView () <UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;
@property (nonatomic, strong) UIView *bottomToolView;
@property (nonatomic, strong) UIButton *albumBT;
@property (nonatomic, strong) UIButton *sendBT;

@property (nonatomic, strong) NSMutableArray *photoItems;
@property (nonatomic, strong) NSMutableArray *selectedPhotoItems;

@end

@implementation JTInputAlbumContainerView

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<JTInputActionDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self setup];
}

- (void)setup
{
    __weak typeof(self) weakself = self;
    [[JTSystemAlbumTool sharedCenter] getAssetsFromAllowPickingVideo:YES allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
        [weakself.photoItems addObjectsFromArray:models];
        [weakself.collectionview reloadData];
    }];
    [self addSubview:self.collectionview];
    [self.collectionview registerClass:[JTInputChooseVideoCollectionViewCell class] forCellWithReuseIdentifier:inputChooseVideoIdentifier];
    [self.collectionview registerClass:[JTInputChoosePhotoCollectionViewCell class] forCellWithReuseIdentifier:inputChoosePhotoIdentifier];
    [self addSubview:self.bottomToolView];
    [self.bottomToolView addSubview:self.albumBT];
    [self.bottomToolView addSubview:self.sendBT];
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSMutableArray *assets = [NSMutableArray array];
//    for (TZAssetModel *model in self.photoItems) {
//        [assets addObject:model.asset];
//    }
//    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc] initWithSelectedAssets:assets selectedPhotos:nil index:0];
//    imagePickerVC.navigationBar.barTintColor = WhiteColor;
//    imagePickerVC.navigationBar.tintColor = BlackLeverColor5;
//    imagePickerVC.navigationBar.titleTextAttributes = @{NSFontAttributeName: Font(18), NSForegroundColorAttributeName: BlackLeverColor6};
//    imagePickerVC.barItemTextColor = BlackLeverColor3;
//    imagePickerVC.barItemTextFont = Font(14);
//    imagePickerVC.allowTakePicture = NO;
//    imagePickerVC.selectedAssets = [NSMutableArray array];
//    [[Utility currentViewController] presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)albumClick:(id)sender
{
    JTImagePickerController *imagePickerVC = [[JTImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];
    imagePickerVC.isJTTheme = YES;
    imagePickerVC.selectedModels = [self.selectedPhotoItems mutableCopy];
    imagePickerVC.delegate = self;
    
    __weak typeof(self) weakself = self;
    [imagePickerVC setDidFinishPhotosHandle:^(NSArray<UIImage *> *photos) {
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(onSendPhotos:)]) {
            [weakself.delegate onSendPhotos:photos];
        }
    }];
    [imagePickerVC setDidFinishVideoHandle:^(NSString *outputPath) {
        if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(onSendVideoPath:)]) {
            [weakself.delegate onSendVideoPath:outputPath];
        }
    }];
    [[Utility currentViewController] presentViewController:imagePickerVC animated:YES completion:nil];
}

- (void)sendClick:(id)sender
{
    if (self.selectedPhotoItems.count > 0) {
         __weak typeof(self) weakself = self;
        PHAsset *firstAsset = [(TZAssetModel *)[self.selectedPhotoItems firstObject] asset];
        if (firstAsset.mediaType == PHAssetMediaTypeImage) {
            [[JTSystemAlbumTool sharedCenter] getOriginalPhotoWithAssetModels:self.selectedPhotoItems completion:^(NSArray<UIImage *> * _Nonnull photos) {
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(onSendPhotos:)]) {
                    [weakself.delegate onSendPhotos:photos];
                    [weakself.selectedPhotoItems removeAllObjects];
                    [weakself.collectionview reloadData];
                }
            }];
        }
        else
        {
            [[JTSystemAlbumTool sharedCenter] getVideoOutputPathWithAsset:[self.selectedPhotoItems.firstObject asset] completion:^(NSString * _Nonnull outputPath) {
                if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(onSendVideoPath:)]) {
                    [weakself.delegate onSendVideoPath:outputPath];
                    [weakself.selectedPhotoItems removeAllObjects];
                    [weakself.collectionview reloadData];
                }
            }];
        }
    }
}

#pragma mark UICollectionViewDataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // ios8 以上都用PHAsset
    PHAsset *asset = [(TZAssetModel *)[self.photoItems objectAtIndex:indexPath.row] asset];
    return CGSizeMake(asset.pixelWidth*collectionView.height/asset.pixelHeight, collectionView.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
{
    return MIN(self.photoItems.count, 50);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TZAssetModel *model = (TZAssetModel *)[self.photoItems objectAtIndex:indexPath.row];
    PHAsset *currentAsset = (PHAsset *)[model asset];
    UICollectionViewCell *cell;
    if (currentAsset.mediaType == PHAssetMediaTypeVideo) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputChooseVideoIdentifier forIndexPath:indexPath];
        [(JTInputChooseVideoCollectionViewCell *)cell timeLB].text = model.timeLength;
    }
    else
    {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputChoosePhotoIdentifier forIndexPath:indexPath];
    }
    [[JTSystemAlbumTool sharedCenter] requestImageForAsset:currentAsset targetSize:CGSizeMake(cell.width*2, cell.height*2) contentMode:PHImageContentModeAspectFit resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [(JTInputChoosePhotoCollectionViewCell *)cell imageView].image = result;
    }];
    [(JTInputChoosePhotoCollectionViewCell *)cell choiceBT].selected = [self.selectedPhotoItems containsObject:model];
    __weak typeof(self) weakself = self;
    [(JTInputChoosePhotoCollectionViewCell *)cell setDidSelectPhotoBlock:^{
        if ([weakself.selectedPhotoItems containsObject:model]) {
            [weakself.selectedPhotoItems removeObject:model];
        }
        else
        {
            if (weakself.selectedPhotoItems.count >= 9) {
                [Utility showAlertMessage:@"你最多只能选择9张图片"];
                return;
            }
            if (weakself.selectedPhotoItems.count > 0) {
                PHAsset *firstAsset = [(TZAssetModel *)[weakself.selectedPhotoItems firstObject] asset];
                if (firstAsset.mediaType != currentAsset.mediaType) {
                    [Utility showAlertMessage:@"不能同时选择照片和视频"];
                    return;
                }
            }
            [weakself.selectedPhotoItems addObject:model];
        }
        [collectionView reloadItemsAtIndexPaths:@[indexPath]];
    }];
    return cell;
}

#pragma mark UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self.selectedPhotoItems removeAllObjects];
    [self.collectionview reloadData];
}

- (UICollectionView *)collectionview
{
    if (!_collectionview) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height-self.bottomToolView.height) collectionViewLayout:layout];
        _collectionview.dataSource = self;
        _collectionview.delegate = self;
        _collectionview.backgroundColor = WhiteColor;
        _collectionview.showsVerticalScrollIndicator = NO;
        _collectionview.showsHorizontalScrollIndicator = NO;
        _collectionview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _collectionview;
}

- (UIView *)bottomToolView
{
    if (!_bottomToolView) {
        _bottomToolView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-input_bottomToolHeight, self.width, input_bottomToolHeight)];
    }
    return _bottomToolView;
}

- (UIButton *)albumBT
{
    if (!_albumBT) {
        _albumBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumBT setTitle:@"相册" forState:UIControlStateNormal];
        [_albumBT setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
        _albumBT.titleLabel.font = Font(15);
        _albumBT.frame = CGRectMake(0, 0, 50, input_bottomToolHeight);
        [_albumBT addTarget:self action:@selector(albumClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _albumBT;
}

- (UIButton *)sendBT
{
    if (!_sendBT) {
        _sendBT = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendBT.backgroundColor = BlueLeverColor1;
        [_sendBT setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBT setTitleColor:WhiteColor forState:UIControlStateNormal];
        _sendBT.titleLabel.font = Font(15);
        _sendBT.frame = CGRectMake(self.bottomToolView.width-80, (input_bottomToolHeight-30)/2, 70, 30);
        _sendBT.layer.cornerRadius = 15;
        [_sendBT addTarget:self action:@selector(sendClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBT;
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(size.width, input_containerHeight);
}

- (NSMutableArray *)photoItems
{
    if (!_photoItems) {
        _photoItems = [NSMutableArray array];
    }
    return _photoItems;
}

- (NSMutableArray *)selectedPhotoItems
{
    if (!_selectedPhotoItems) {
        _selectedPhotoItems = [NSMutableArray array];
    }
    return _selectedPhotoItems;
}

@end
