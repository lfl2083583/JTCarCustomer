//
//  Utility.h
//  ZTML
//
//  Created by 周涛 on 14/11/6.
//  Copyright (c) 2014年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Utility : NSObject

+ (UIViewController *)currentViewController;
+ (UIWindow *)mainWindow;

+ (void)showAlertMessage:(NSString *)atMessage;
+ (void)showAlertTitle:(NSString *)atTitle Message:(NSString *)atMessage;

+ (BOOL)networkDetection;
+ (void)startTime:(UIButton *)sender;
+ (CGSize)getTextString:(NSString *)text textFont:(UIFont *)font frameWidth:(float)width attributedString:(NSMutableAttributedString *)attributedString;

+ (NSString *)currentTime:(NSDate *)date;
+ (NSString *)exchageTimeInterval:(NSInteger)timeInterval format:(NSString *)format;
+ (NSString *)exchageDate:(NSDate *)date format:(NSString *)format;
+ (NSString *)showTime:(NSTimeInterval)msglastTime showDetail:(BOOL)showDetail;

+ (UIView *)initLineRect:(CGRect)rect lineColor:(UIColor *)lineColor;
+ (CAShapeLayer *)setLayerWithRect:(CGRect)rect radii:(CGSize)size;
+ (void)richTextLabel:(UILabel *)label fontNumber:(id)font andRange:(NSRange)range andColor:(UIColor *)vaColor;
+ (void)downloadImageWithURLString:(NSString *)urlString success:(void (^)(UIImage *image))success;
+ (void)downloadImageWithURLStrings:(NSArray *)urlStrings success:(void (^)(NSMutableArray<UIImage *> *images))success;
+ (BOOL)isHeadsetPluggedIn;

@end
