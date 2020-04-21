//
//  HUDTool.m
//  QTNewIMApp
//
//  Created by apple on 2017/3/30.
//  Copyright © 2017年 z. All rights reserved.
//

#import "HUDTool.h"

static HUDTool *hudTool;

@implementation HUDTool

+ (instancetype)shareHUDTool
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hudTool = [[HUDTool alloc] init];
    });
    return hudTool;
}

- (UIWindow *)mainWindow
{
    UIApplication *app = [UIApplication sharedApplication];
    if ([app.delegate respondsToSelector:@selector(window)])
    {
        return [app.delegate window];
    }
    else
    {
        return [app keyWindow];
    }
}

- (void)showHint:(NSString *)hint
{
    [self showHint:hint yOffset:[UIScreen mainScreen].bounds.size.height/2 - 100];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset
{
    [self showHint:hint yOffset:yOffset HUDMode:MBProgressHUDModeText];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset HUDMode:(MBProgressHUDMode)HUDMode
{
    [self showHint:hint yOffset:yOffset HUDMode:HUDMode autoHide:YES];
}

- (void)showHint:(NSString *)hint yOffset:(float)yOffset HUDMode:(MBProgressHUDMode)HUDMode autoHide:(BOOL)autoHide
{
    
    [self hideHUD];
    
    _hud = [MBProgressHUD showHUDAddedTo:[self mainWindow] animated:YES];
    _hud.label.font = [UIFont systemFontOfSize:15];
    _hud.label.textColor = [UIColor whiteColor];
    _hud.customView.backgroundColor = [UIColor blackColor];
    _hud.removeFromSuperViewOnHide = YES;
    
    [[self mainWindow] addSubview:self.hud];
    
    _hud.alpha = 1.f;
    _hud.mode = HUDMode;
    _hud.label.text = hint;
    _hud.offset = CGPointMake(0, yOffset);
    
    if (HUDMode == MBProgressHUDModeText) {
        self.hud.margin = 10.f;
        self.hud.minSize = CGSizeMake(100, 20);
        self.hud.userInteractionEnabled = NO;
    }
    else
    {
        self.hud.margin = 20.f;
        self.hud.minSize = CGSizeZero;
        self.hud.userInteractionEnabled = YES;
    }
    if (autoHide) {
        [self.hud hideAnimated:YES afterDelay:3];
    }
    else
    {
        [self.hud showAnimated:YES];
    }
}

- (void)showHint:(NSString *)hint progress:(float)progress yOffset:(float)yOffset
{
    if (_hud && _hud.mode == MBProgressHUDModeDeterminate) {
        
    }
    else
    {
        [self hideHUD];
        
        _hud = [MBProgressHUD showHUDAddedTo:[self mainWindow] animated:YES];
        _hud.label.font = [UIFont systemFontOfSize:15];
        _hud.label.textColor = [UIColor whiteColor];
        _hud.customView.backgroundColor = [UIColor blackColor];
        _hud.removeFromSuperViewOnHide = YES;
        
        [[self mainWindow] addSubview:self.hud];
        
        _hud.alpha = 1.f;
        _hud.mode = MBProgressHUDModeDeterminate;
        _hud.label.text = hint;
        _hud.offset = CGPointMake(0, yOffset);
        _hud.userInteractionEnabled = NO;
        
        [self.hud showAnimated:YES];
    }
    
    if (progress == 1) {
        [_hud hideAnimated:YES afterDelay:1];
    }
    else
    {
        _hud.progress = progress;
    }
}

- (void)hideHUD
{
    if (_hud) {
        [self.hud hideAnimated:YES];
    }
}

@end
