//
//  JTDeviceAccess.h
//  JTSocial
//
//  Created by apple on 2017/12/26.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTDeviceAccess : NSObject


/**
 检查是否能获取相机权限

 @param tipMessage 提示
 @param result result description
 */
+ (void)checkCameraEnable:(NSString *)tipMessage result:(void(^)(BOOL result))result;

/**
 检查是否能获取相册权限

 @param tipMessage 提示
 @param result result description
 */
+ (void)checkAlbumEnable:(NSString *)tipMessage result:(void(^)(BOOL result))result;

/**
 检查是否能获取麦克风权限

 @param tipMessage 提示
 @param result result description
 */
+ (void)checkMicrophoneEnable:(NSString *)tipMessage result:(void(^)(BOOL result))result;

/**
 检查是否能访问网络权限

 @param tipMessage 提示
 @param result result description
 */
+ (void)checkNetworkEnable:(NSString *)tipMessage result:(void(^)(BOOL result))result;

/**
 检查是否能访问位置权限
 
 @param tipMessage 提示
 @param result result description
 */
+ (void)checkLocationEnable:(NSString *)tipMessage result:(void(^)(BOOL result))result;
@end
