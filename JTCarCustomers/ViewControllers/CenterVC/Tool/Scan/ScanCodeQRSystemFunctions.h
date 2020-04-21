//
//  ScanCodeQRSystemFunctions.h
//  JTSocial
//
//  Created by apple on 2017/7/29.
//  Copyright © 2017年 JTTeam. All rights reserved.
//
#import <AVFoundation/AVCaptureDevice.h>
#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "QRHeader.h"

typedef enum : NSUInteger {
    QRCodeTypeWebUrl,
    QRCodeTypeUser,
    QRCodeTypeSession,
    QRCodeTypeGroup,
    QRCodeTypeInviteCode
    
} QRCodeType;

@interface ScanCodeQRSystemFunctions : NSObject


/**
 *是否开启系统照明灯
 *@param   opened   是否打开
 */
+ (void)openLight:(BOOL)opened;

/**
 *是否开启系统震动和声音
 *@param   shaked   是否开启震动
 *@param   sounding   是否开启声音
 */
+ (void)openShake:(BOOL)shaked Sound:(BOOL)sounding;

/**
 *  处理扫码信息
 *
 *  @param message 扫码信息
 *  @param success 成功消息
 *  @param failure 失败消息
 */
+ (void)showInSafariWithURLMessage:(NSString *)message Success:(void (^)(id source, QRCodeType qrcodeType, id info))success Failure:(void (^)(NSError *error))failure;

@end
