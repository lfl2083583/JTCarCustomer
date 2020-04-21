//
//  JTDeviceAccess.m
//  JTSocial
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTDeviceAccess.h"
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CLLocationManager.h>

@implementation JTDeviceAccess

+ (void)checkCameraEnable:(NSString *)tipMessage result:(void(^)(BOOL))result {
    dispatch_async_main_safe(^{
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:tipMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                if (result) {
                    result(NO);
                }
            }];
            [alertController addAction:confirmAction];
            [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
        } else {
            if (result) {
                result(YES);
            }
        }
    });
}

+ (void)checkAlbumEnable:(NSString *)tipMessage result:(void(^)(BOOL result))result
{
    dispatch_async_main_safe(^{
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:tipMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                if (result) {
                    result(NO);
                }
            }];
            [alertController addAction:confirmAction];
            [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
        } else {
            if (result) {
                result(YES);
            }
        }
    });
}

+ (void)checkMicrophoneEnable:(NSString *)tipMessage result:(void(^)(BOOL))result {
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            dispatch_async_main_safe(^{
                if (!granted) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:tipMessage preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                        if (result) {
                            result(NO);
                        }
                    }];
                    [alertController addAction:confirmAction];
                    [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
                }
                else
                {
                    if (result) {
                        result(YES);
                    }
                }
            });
        }];
    }
}

+ (void)checkNetworkEnable:(NSString *)tipMessage result:(void(^)(BOOL))result {
    dispatch_async_main_safe(^{
        if ([HttpRequestTool sharedInstance].networkStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            if (result) {
                result(YES);
            }
        }
        else if ([HttpRequestTool sharedInstance].networkStatus == AFNetworkReachabilityStatusReachableViaWWAN)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:tipMessage preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction: [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                if (result) {
                    result(NO);
                }
            }]];
            [alertController addAction: [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                if (result) {
                    result(YES);
                }
            }]];
            [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            [[HUDTool shareHUDTool] showHint:@"当前网络不可用，请检查网络"];
            if (result) {
                result(NO);
            }
        }
    });
}

+ (void)checkLocationEnable:(NSString *)tipMessage result:(void(^)(BOOL result))result
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        if (result) {
            result(YES);
        }
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:tipMessage preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            if (result) {
                result(NO);
            }
        }];
        [alertController addAction:confirmAction];
        [[Utility currentViewController] presentViewController:alertController animated:YES completion:nil];
    }
}
@end
