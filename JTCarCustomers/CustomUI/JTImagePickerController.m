//
//  JTImagePickerController.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTImagePickerController.h"

@interface JTImagePickerController ()

@end

@implementation JTImagePickerController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setIsJTTheme:(BOOL)isJTTheme
{
    if (isJTTheme) {
        self.navigationBar.barTintColor = WhiteColor;
        self.navigationBar.tintColor = BlackLeverColor5;
        self.navigationBar.titleTextAttributes = @{NSFontAttributeName: Font(18), NSForegroundColorAttributeName: BlackLeverColor6};
        self.barItemTextColor = BlackLeverColor3;
        self.barItemTextFont = Font(14);
        self.allowTakePicture = NO;
        self.photoDefImageName = @"icon_accessory_normal";
        self.photoSelImageName = @"icon_accessory_selected";
        self.photoNumberIconImageName = @"icon_accessory";
        self.oKButtonTitleColorNormal = BlueLeverColor1;
        self.oKButtonTitleColorDisabled = [BlueLeverColor1 colorWithAlphaComponent:.5];
    }
}

- (void)setDidFinishPhotosHandle:(void (^)(NSArray<UIImage *> *))didFinishPhotosHandle
{
    _didFinishPhotosHandle = didFinishPhotosHandle;
    __weak typeof(self) weakself = self;
    [self setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        __strong typeof(weakself) strongself = weakself;
        strongself.didFinishPhotosHandle(photos);
    }];
}

- (void)setDidFinishVideoHandle:(void (^)(NSString *))didFinishVideoHandle
{
    _didFinishVideoHandle = didFinishVideoHandle;
    __weak typeof(self) weakself = self;
    [self setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
        __strong typeof(weakself) strongself = weakself;
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
                strongself.didFinishVideoHandle(outputPath);
            }
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
