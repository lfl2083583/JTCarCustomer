//
//  JTSystemAlbumTool.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZImageManager.h"
#import "TZAssetModel.h"

@interface JTSystemAlbumTool : NSObject

@property (nonatomic, strong) PHImageRequestOptions * _Nullable imageRequestOptions;

+ (JTSystemAlbumTool *_Nonnull)sharedCenter;

/**
 获取本地相册

 @param allowPickingVideo 是否获取视频
 @param allowPickingImage 是否获取照片
 @param completion completion description
 */
- (void)getAssetsFromAllowPickingVideo:(BOOL)allowPickingVideo allowPickingImage:(BOOL)allowPickingImage completion:(void (^_Nullable)(NSArray<TZAssetModel *> * _Nullable models))completion;

- (void)getOriginalPhotoWithAssetModels:(NSArray<TZAssetModel *> *_Nullable)assetModels completion:(void (^_Nonnull)(NSArray<UIImage *> * _Nonnull photos))completion;
- (void)getOriginalPhotoWithAssets:(NSArray<id> *_Nullable)assets completion:(void (^_Nonnull)(NSArray<UIImage *> * _Nonnull photos))completion;
- (void)getOriginalPhotoWithAsset:(id _Nonnull )asset completion:(void (^_Nonnull)(UIImage * _Nonnull photo))completion;
- (void)getVideoOutputPathWithAsset:(id _Nonnull )asset completion:(void (^_Nonnull)(NSString * _Nonnull outputPath))completion;
- (PHImageRequestID)requestImageForAsset:(PHAsset *_Nullable)asset targetSize:(CGSize)targetSize contentMode:(PHImageContentMode)contentMode resultHandler:(void (^_Nullable)(UIImage *__nullable result, NSDictionary *__nullable info))resultHandler;
@end
