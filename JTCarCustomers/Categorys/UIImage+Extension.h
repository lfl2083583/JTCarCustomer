//
//  UIImage+Extension.h
//  GCHCustomerMall
//
//  Created by 观潮汇 on 16/6/17.
//  Copyright © 2016年 观潮汇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)imageWithName:(NSString *)imageName bundleName:(NSString *)bundleName;

/**
 用rgb绘制图片

 @param color 色值
 @param rect 范围
 @return 图片
 */
+ (UIImage *)graphicsImageWithColor:(UIColor *)color rect:(CGRect)rect;

/**
 获取当前屏幕快照

 @return 图片
 */
+ (UIImage *)imageWithScreenshot;

/**
 图片高斯模糊

 @param blur 模糊值
 @return 图片
 */
- (UIImage *)boxblurNumber:(CGFloat)blur;

/**
 图片MD5

 @return 返回MD5值
 */
- (NSString *)MD5String;
@end
