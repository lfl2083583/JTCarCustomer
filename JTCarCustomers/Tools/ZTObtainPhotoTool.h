//
//  ZTObtainPhotoTool.h
//  BOOOP
//
//  Created by booop on 15/2/2.
//  Copyright (c) 2015年 booop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPImageCropperViewController.h"

typedef NS_ENUM(NSInteger, JTPhotoEditType) {
    JTPhotoEditTypeDisable,
    JTPhotoEditTypeNormal,
    JTPhotoEditTypeCustom,
};

@interface ZTObtainPhotoTool : NSObject <UIImagePickerControllerDelegate, UINavigationControllerDelegate, VPImageCropperDelegate>

@property (copy, nonatomic) void(^success)(UIImage *image);
@property (copy, nonatomic) void(^cancel)(void);
@property (weak, nonatomic) UIViewController *viewController;
@property (assign, nonatomic) JTPhotoEditType photoEditType;

+ (ZTObtainPhotoTool *)shareObtainPhotoTool;
- (void)show:(UIViewController *)aViewController success:(void (^)(UIImage *image))aSuccess cancel:(void (^)(void))aCancel;
- (void)show:(UIViewController *)aViewController photoEditType:(JTPhotoEditType)photoEditType success:(void (^)(UIImage *image))aSuccess cancel:(void (^)(void))aCancel;
/**
 调取相机或相册

 @param aViewController 根视图
 @param index 0.相机 1.相册 2.选择框
 @param photoEditType 编辑类型
 @param aSuccess 成功回调
 @param aCancel 失败回调
 */
- (void)show:(UIViewController *)aViewController sourceType:(NSInteger)index photoEditType:(JTPhotoEditType)photoEditType success:(void (^)(UIImage *image))aSuccess cancel:(void (^)(void))aCancel;
/**
 调取相机或相册

 @param index 0.相机 1.相册
 */
- (void)showImagePickerSourceType:(NSInteger)index;
@end
