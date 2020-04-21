//
//  HUDTool.h
//  QTNewIMApp
//
//  Created by apple on 2017/3/30.
//  Copyright © 2017年 z. All rights reserved.
//

#import "MBProgressHUD.h"
#import <Foundation/Foundation.h>

@interface HUDTool : NSObject

@property (strong, nonatomic) MBProgressHUD *hud;

+ (instancetype)shareHUDTool;

- (void)showHint:(NSString *)hint;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset HUDMode:(MBProgressHUDMode)HUDMode;

- (void)showHint:(NSString *)hint yOffset:(float)yOffset HUDMode:(MBProgressHUDMode)HUDMode autoHide:(BOOL)autoHide;

- (void)showHint:(NSString *)hint progress:(float)progress yOffset:(float)yOffset;

- (void)hideHUD;
@end
