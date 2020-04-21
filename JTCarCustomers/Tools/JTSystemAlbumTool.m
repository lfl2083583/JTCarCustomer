//
//  JTSystemAlbumTool.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSystemAlbumTool.h"


@implementation JTSystemAlbumTool

+ (JTSystemAlbumTool *)sharedCenter
{
    static JTSystemAlbumTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTSystemAlbumTool alloc] init];
    });
    return instance;
}

- (void)getAssetsFromAllowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^_Nullable)(NSArray<TZAssetModel *> * _Nullable models))completion
{
    PHFetchOptions *fetchOptions = [[PHFetchOptions alloc] init];
    //ascending 为YES时，按照照片的创建时间升序排列;为NO时，则降序排列
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    
    [[TZImageManager manager] getAssetsFromFetchResult:fetchResult allowPickingVideo:allowPickingVideo allowPickingImage:allowPickingImage completion:^(NSArray<TZAssetModel *> *models) {
        completion(models);
    }];
}

- (void)getOriginalPhotoWithAssetModels:(NSArray<TZAssetModel *> *_Nullable)assetModels completion:(void (^_Nonnull)(NSArray<UIImage *> * _Nonnull photos))completion
{
    NSMutableArray *photos = [NSMutableArray array];
    for (TZAssetModel *model in assetModels) {
        [self getOriginalPhotoWithAsset:model.asset completion:^(UIImage *photo) {
            [photos addObject:photo];
            if (photos.count == assetModels.count) {
                completion(photos);
            }
        }];
    }
}

- (void)getOriginalPhotoWithAssets:(NSArray<id> *_Nullable)assets completion:(void (^_Nonnull)(NSArray<UIImage *> * _Nonnull photos))completion
{
    NSMutableArray *photos = [NSMutableArray array];
    for (id asset in assets) {
        [self getOriginalPhotoWithAsset:asset completion:^(UIImage *photo) {
            [photos addObject:photo];
            if (photos.count == assets.count) {
                completion(photos);
            }
        }];
    }
}

- (void)getOriginalPhotoWithAsset:(id _Nonnull )asset completion:(void (^_Nonnull)(UIImage * _Nonnull photo))completion
{
    [[TZImageManager manager] getOriginalPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info) {
        completion(photo);
    }];
}

- (void)getVideoOutputPathWithAsset:(id _Nonnull )asset completion:(void (^_Nonnull)(NSString * _Nonnull outputPath))completion
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[HUDTool shareHUDTool] showHint:@"视频处理中..." yOffset:0 HUDMode:MBProgressHUDModeIndeterminate autoHide:NO];
    });
    [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
        if ([outputPath isBlankString]) {
            [[HUDTool shareHUDTool] showHint:@"视频处理失败，请选择其他视频"];
        }
        else
        {
            [[HUDTool shareHUDTool] hideHUD];
            completion(outputPath);
        }
    }];
}

- (PHImageRequestID)requestImageForAsset:(PHAsset *)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode resultHandler:(void (^)(UIImage * _Nullable, NSDictionary * _Nullable))resultHandler
{
    PHImageRequestID requestID = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:self.imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        resultHandler(result, info);
    }];
    return requestID;
}

- (PHImageRequestOptions *)imageRequestOptions
{
    if (!_imageRequestOptions) {
        _imageRequestOptions = [[PHImageRequestOptions alloc] init];
        /*
         设置显示模式
         PHImageRequestOptionsResizeModeNone    //选了这个就不会管传如的size了 ，要自己控制图片的大小，建议还是选Fast
         PHImageRequestOptionsResizeModeFast    //根据传入的size，迅速加载大小相匹配(略大于或略小于)的图像
         PHImageRequestOptionsResizeModeExact    //精确的加载与传入size相匹配的图像
         */
        _imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
        _imageRequestOptions.networkAccessAllowed = YES;
        /*指定请求是否同步执行。*/
        _imageRequestOptions.synchronous = NO;
        /*
         deliveryMode：图像质量。有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
         这个属性只有在 synchronous 为 true 时有效。
         */
        _imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    return _imageRequestOptions;
}

@end
