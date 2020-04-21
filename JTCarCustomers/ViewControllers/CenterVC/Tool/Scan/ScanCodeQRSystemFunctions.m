//
//  ScanCodeQRSystemFunctions.m
//  JTSocial
//
//  Created by apple on 2017/7/29.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "ScanCodeQRSystemFunctions.h"

@implementation ScanCodeQRSystemFunctions

+ (void)openLight:(BOOL)opened {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType: AVMediaTypeVideo];
    if (![device hasTorch]) {
    } else {
        if (opened) {
            // 开启闪光灯
            if(device.torchMode != AVCaptureTorchModeOn ||
               device.flashMode != AVCaptureFlashModeOn) {
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                [device unlockForConfiguration];
            }
        } else {
            // 关闭闪光灯
            if(device.torchMode != AVCaptureTorchModeOff ||
               device.flashMode != AVCaptureFlashModeOff) {
                [device lockForConfiguration:nil];
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
                [device unlockForConfiguration];
            }
        }
    }
}

+ (void)openShake:(BOOL)shaked Sound:(BOOL)sounding {
    if (shaked) {
        //开启系统震动
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
    if (sounding) {
        //设置自定义声音
        SystemSoundID soundID;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:ringPath ofType:ringType]], &soundID);
        AudioServicesPlaySystemSound(soundID);
    }
}

+ (void)showInSafariWithURLMessage:(NSString *)message Success:(void (^)(id source, QRCodeType qrcodeType, id info))success Failure:(void (^)(NSError *error))failure {
    NSError *error;
    if (!message || [message isBlankString]) {
        failure(error);
    }
    else
    {
        if ([message hasPrefix:@"http://"] || [message hasPrefix:@"https://"]) {
            if ([message containsString:@"agent/url"]) {
                NSString *icode = [[message componentsSeparatedByString:@"/"] lastObject];
                success(icode, QRCodeTypeInviteCode, nil);
            }
            else if ([message containsString:@"http://h5.6che.vip/jump?action=addgroup&"]) {
                NSString *prefix = @"http://h5.6che.vip/jump?action=addgroup&";
                NSString *result = [message substringFromIndex:prefix.length];
                NSArray *array = [result componentsSeparatedByString:@"&"];
                if (array && [array isKindOfClass:[NSArray class]] && array.count == 4) {
                    NSString *str1 = array[0];
                    NSString *str2 = array[1];
                    NSString *str3 = array[2];
                    NSString *str4 = array[3];
                    NSString *teamID = [str1 substringFromIndex:8];;
                    NSString *inveterID = [str2 substringFromIndex:8];
                    NSString *inviteTime = [str3 substringFromIndex:2];
                    NSString *market = [str4 substringFromIndex:7];
                    NSMutableDictionary *progem = [NSMutableDictionary dictionary];
                    [progem setObject:teamID forKey:@"teamID"];
                    [progem setValue:inveterID forKey:@"inveterID"];
                    [progem setValue:inviteTime forKey:@"inviteTime"];
                    [progem setValue:market forKey:@"market"];
                    BOOL isJoin = [[NIMSDK sharedSDK].teamManager isMyTeam:teamID];
                    if (isJoin && success) {
                        success(teamID, QRCodeTypeSession, nil);
                    }
                    else if (!isJoin)
                    {
                        [[NIMSDK sharedSDK].teamManager fetchTeamInfo:teamID completion:^(NSError * _Nullable error, NIMTeam * _Nullable team) {
                            if (team && success && [market isEqualToString:@"qr"]) {
                                success(progem, QRCodeTypeGroup, team);
                            } else if (!team) {
                                [[HUDTool shareHUDTool] showHint:@"此群不存在" yOffset:0];
                            }
                        }];
                    }
                    else
                    {
                       failure(error);
                    }
                }
            }
            else if ([message containsString:@"http://h5.6che.vip/jump?action=addfriend&"])
            {
                NSString *prefix = @"http://h5.6che.vip/jump?action=addfriend&";
                NSString *result = [message substringFromIndex:prefix.length];
                NSArray *array = [result componentsSeparatedByString:@"&"];
                if (array && [array isKindOfClass:[NSArray class]] && array.count == 3) {
                    NSString *str1 = array[0];
                    NSString *str2 = array[1];
                    NSString *str3 = array[2];
                    NSString *userID = [str1 substringFromIndex:7];
                    NSString *inviteTime = [str2 substringFromIndex:2];
                    NSString *market = [str3 substringFromIndex:7];
                    NSMutableDictionary *progem = [NSMutableDictionary dictionary];
                    [progem setObject:userID forKey:@"userID"];
                    [progem setValue:inviteTime forKey:@"inviteTime"];
                    [progem setValue:market forKey:@"market"];
                    if (success) {
                        success(progem, QRCodeTypeUser, nil);
                    }
                    else
                    {
                        failure(error);
                    }
                }
            }
            else
            {
                success(message, QRCodeTypeWebUrl, nil);
            }
        }
        else
        {
            failure(error);
        }
    }
}
@end
