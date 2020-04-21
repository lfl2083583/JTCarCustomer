//
//  ZTObtainPhotoTool.m
//  BOOOP
//
//  Created by booop on 15/2/2.
//  Copyright (c) 2015年 booop. All rights reserved.
//

#import "ZTObtainPhotoTool.h"

static ZTObtainPhotoTool *obtainPhotoTool = nil;

@implementation ZTObtainPhotoTool

+ (ZTObtainPhotoTool *)shareObtainPhotoTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obtainPhotoTool = [[ZTObtainPhotoTool alloc] init];
    });
    return obtainPhotoTool;
}

- (void)show:(UIViewController *)aViewController success:(void (^)(UIImage *))aSuccess cancel:(void (^)(void))aCancel
{
    [self show:aViewController sourceType:2 photoEditType:JTPhotoEditTypeNormal success:aSuccess cancel:aCancel];
}

- (void)show:(UIViewController *)aViewController photoEditType:(JTPhotoEditType)photoEditType success:(void (^)(UIImage *image))aSuccess cancel:(void (^)(void))aCancel;
{
    [self show:aViewController sourceType:2 photoEditType:photoEditType success:aSuccess cancel:aCancel];
}

- (void)show:(UIViewController *)aViewController sourceType:(NSInteger)index photoEditType:(JTPhotoEditType)photoEditType success:(void (^)(UIImage *))aSuccess cancel:(void (^)(void))aCancel
{
    _viewController = aViewController;
    _photoEditType = photoEditType;
    _success = aSuccess;
    _cancel = aCancel;
    
    if (index == 2) {
        __weak typeof(self) weakself = self;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel                                                                 handler:^(UIAlertAction * action) {
            if (weakself.cancel) {
                weakself.cancel();
            }
        }];
        UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
            
            [weakself checkPowerSourceType:0];
        }];
        UIAlertAction *pictureAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault                                                                 handler:^(UIAlertAction * action) {
            
            [weakself checkPowerSourceType:1];
        }];
        
        [alertController addAction:cancelAction];
        [alertController addAction:albumAction];
        [alertController addAction:pictureAction];
        [aViewController presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        [self checkPowerSourceType:index];
    }
}

- (void)checkPowerSourceType:(NSInteger)index
{
    __weak typeof(self) weakself = self;
    if (index == 0) {
        [JTDeviceAccess checkCameraEnable:@"相机权限受限,无法拍照" result:^(BOOL result) {
            if (result) {
                [weakself showImagePickerSourceType:index];
            }
        }];
    }
    else
    {
        [JTDeviceAccess checkAlbumEnable:@"相册权限受限,无法选取本地照片" result:^(BOOL result) {
            if (result) {
                [weakself showImagePickerSourceType:index];
            }
        }];
    }
}

- (void)showImagePickerSourceType:(NSInteger)index
{
    if (@available(iOS 11, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = (index == 1)?UIImagePickerControllerSourceTypePhotoLibrary:UIImagePickerControllerSourceTypeCamera;
    imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = (self.photoEditType == JTPhotoEditTypeNormal);
    [_viewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    }
    UIImage *photo = [info objectForKey:(self.photoEditType == JTPhotoEditTypeNormal)?UIImagePickerControllerEditedImage:UIImagePickerControllerOriginalImage];
    if (self.photoEditType == JTPhotoEditTypeCustom) {
        // 自定义编辑框的frame 
        CGFloat cropWith = App_Frame_Width;
        CGFloat cropHeight = App_Frame_Width;
        VPImageCropperViewController *imageCropperVC = [[VPImageCropperViewController alloc] initWithImage:photo cropFrame:CGRectMake(0, (APP_Frame_Height-cropHeight)/2.0, cropWith, cropHeight) limitScaleRatio:5];
        imageCropperVC.delegate = self;
        [picker pushViewController:imageCropperVC animated:YES];
    }
    else
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
        if (self.success) {
            self.success(photo);
        }
        if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
    if (self.success) {
        self.success(editedImage);
    }
    UIImageWriteToSavedPhotosAlbum(editedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    if (@available(iOS 11, *)) {
        [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever; //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
    }
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}

@end
