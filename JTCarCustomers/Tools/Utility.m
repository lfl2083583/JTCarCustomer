//
//  Utility.m
//  ZTML
//
//  Created by 周涛 on 14/11/6.
//  Copyright (c) 2014年 long. All rights reserved.
//

#import "Utility.h"
#import "MMDrawerController.h"
#import <AVFoundation/AVFoundation.h>

@implementation Utility

/**
 获取当前视图

 @return return value description
 */
+ (UIViewController *)currentViewController
{
    UIViewController *result = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return [self getTopViewController:result];
}

+ (UIViewController *)getTopViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[MMDrawerController class]]) {
        return [self getTopViewController:[(MMDrawerController *)viewController centerViewController]];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [self getTopViewController:[(UITabBarController *)viewController selectedViewController]];
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [self getTopViewController:[(UINavigationController *)viewController topViewController]];
    } else if (viewController.presentedViewController) {
        return [self getTopViewController:viewController.presentedViewController];
    } else {
        return viewController;
    }
}

/**
 *  获取主窗口
 *
 *  @return return value description
 */
+ (UIWindow *)mainWindow
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

/**
 弹出消息提示框

 @param atMessage 消息
 */
+ (void)showAlertMessage:(NSString *)atMessage
{
    [self showAlertTitle:nil Message:atMessage];
}

/**
 *  弹出消息提示框
 *
 *  @param atTitle   标题
 *  @param atMessage 消息
 */
+ (void)showAlertTitle:(NSString *)atTitle Message:(NSString *)atMessage
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:atTitle message:atMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    [alertController addAction:confirmAction];
    [[self currentViewController] presentViewController:alertController animated:YES completion:nil];
}

/**
 *  同步判断网络连接
 *
 *  @return YES 表示有网络连接
 */
+ (BOOL)networkDetection
{
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    NSHTTPURLResponse *response;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: nil];
    return (response != nil);
}

/**
 按钮倒计时

 @param sender 按钮
 */
+ (void)startTime:(UIButton *)sender
{
    __block int timeout = 59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [sender setTitle:@"获取验证码" forState:UIControlStateNormal];
                [sender setTitleColor:UIColorFromRGB(0x6987F7) forState:UIControlStateNormal];
                [sender setUserInteractionEnabled:YES];
            });
        } else {
            int seconds = timeout%60;
            NSString *strTime = [NSString stringWithFormat:@"%d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                NSLog(@"____%@",strTime);
                [sender setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                [sender setTitleColor:UIColorFromRGB(0x6987F7) forState:UIControlStateNormal];
                [sender setUserInteractionEnabled:NO];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

/**
 *  检测文字的Size
 *
 *  @param text             文字
 *  @param font             字体
 *  @param width            最大宽度
 *  @param attributedString 富文本（如果attributedString不为nil 会根据attributedString来检测）
 *
 *  @return 文字的Size
 */
+ (CGSize)getTextString:(NSString *)text textFont:(UIFont *)font frameWidth:(float)width attributedString:(NSMutableAttributedString *)attributedString
{
    CGSize constraint = CGSizeMake(width, MAXFLOAT);
    
    if (!attributedString) {
        
        attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{
                                                                                               NSFontAttributeName:font
                                                                                               }];
        
    }
    CGRect rect = [attributedString boundingRectWithSize:constraint
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                 context:nil];
    CGSize size = rect.size;
    return size;
}

/**
 获取当前时间戳
 
 @param date 当前时间
 @return 时间戳
 */
+ (NSString *)currentTime:(NSDate *)date
{
    NSString *curTime = [NSString stringWithFormat:@"%d", (int)[date timeIntervalSince1970]];
    return curTime;
}

/**
 时间戳转换时间

 @param timeInterval 时间戳
 @param format 时间格式
 @return 时间字符串
 */
+ (NSString *)exchageTimeInterval:(NSInteger)timeInterval format:(NSString *)format
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [self exchageDate:date format:format];
}

/**
 NSDate转NSString

 @param date 日期
 @param format 时间格式
 @return NSString
 */
+ (NSString *)exchageDate:(NSDate *)date format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateFormat = format;
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    return [formatter stringFromDate:date];
}

+ (NSTimeInterval)decodeNormalDate:(NSString *)normalDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterMediumStyle;
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateFormat = [@"YYYY-MM-dd HH:mm:ss" substringToIndex:normalDate.length];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    formatter.timeZone = timeZone;
    NSDate *date = [formatter dateFromString:normalDate];
    return [date timeIntervalSince1970];
}

/**
 显示日期
 
 @param msglastTime 需要显示的时间戳
 @param showDetail 是否显示详细日期
 @return 日期
 */
+ (NSString *)showTime:(NSTimeInterval)msglastTime showDetail:(BOOL)showDetail
{
    NSDate *nowDate = [NSDate date];
    NSDate *msgDate = [NSDate dateWithTimeIntervalSince1970:msglastTime];
    NSCalendarUnit components = (NSCalendarUnit)(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute);
    NSDateComponents *nowDateComponents = [[NSCalendar currentCalendar] components:components fromDate:nowDate];
    NSDateComponents *msgDateComponents = [[NSCalendar currentCalendar] components:components fromDate:msgDate];
    
    NSString *result = nil;
    if (nowDateComponents.year == msgDateComponents.year) {
        CGFloat maxInterval = ([nowDate timeIntervalSince1970] - msglastTime) / (24 * 3600);
        if (maxInterval < 3 && nowDateComponents.day == msgDateComponents.day) {
            result = [[NSString alloc] initWithFormat:@"%02d:%02d", (int)msgDateComponents.hour, (int)msgDateComponents.minute];
        }
        else if (maxInterval < 3 && nowDateComponents.day == (msgDateComponents.day + 1)) {
            result = showDetail ? [[NSString alloc] initWithFormat:@"昨天 %02d:%02d", (int)msgDateComponents.hour, (int)msgDateComponents.minute] : @"昨天";
        }
        else if (maxInterval < 3 && nowDateComponents.day == (msgDateComponents.day + 2)) {
            result = showDetail ? [[NSString alloc] initWithFormat:@"前天 %02d:%02d", (int)msgDateComponents.hour, (int)msgDateComponents.minute] : @"前天";
        }
        else if (maxInterval < 7 && nowDateComponents.weekday != msgDateComponents.weekday) {
            NSString *weekDay = [self weekdayStr:msgDateComponents.weekday];
            result = showDetail ? [weekDay stringByAppendingFormat:@" %02d:%02d", (int)msgDateComponents.hour, (int)msgDateComponents.minute] : weekDay;
        }
        else
        {
            NSString *data = [NSString stringWithFormat:@"%zd月%zd日", msgDateComponents.month, msgDateComponents.day];
            result = showDetail ? [data stringByAppendingFormat:@" %02d:%02d", (int)msgDateComponents.hour, (int)msgDateComponents.minute] : data;
        }
    }
    else
    {
        NSString *data = [NSString stringWithFormat:@"%zd年%zd月%zd日", msgDateComponents.year, msgDateComponents.month, msgDateComponents.day];
        result = showDetail ? [data stringByAppendingFormat:@" %02d:%02d", (int)msgDateComponents.hour, (int)msgDateComponents.minute] : data;
    }
    return result;
}

+ (NSString *)weekdayStr:(NSInteger)dayOfWeek
{
    static NSDictionary *daysOfWeekDict = nil;
    daysOfWeekDict = @{@(1):@"星期日",
                       @(2):@"星期一",
                       @(3):@"星期二",
                       @(4):@"星期三",
                       @(5):@"星期四",
                       @(6):@"星期五",
                       @(7):@"星期六",};
    return [daysOfWeekDict objectForKey:@(dayOfWeek)];
}

/**
 创建线条

 @param rect 线条范围
 @param lineColor 线条颜色
 @return 线条
 */
+ (UIView *)initLineRect:(CGRect)rect lineColor:(UIColor *)lineColor
{
    UIView *line = [[UIView alloc] initWithFrame:rect];
    line.backgroundColor = lineColor;
    return line;
}

/**
 画圆

 @param rect rect description
 @param size size description
 @return return value description
 */
+ (CAShapeLayer *)setLayerWithRect:(CGRect)rect radii:(CGSize)size
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    // 将曲线路径设置为layer的路径
    maskLayer.path = path.CGPath;
    
    return maskLayer;
}

/**
 富文本处理

 @param label   对象
 @param font    对象字体
 @param range   有效范围
 @param vaColor 颜色
 */
+ (void)richTextLabel:(UILabel *)label fontNumber:(id)font andRange:(NSRange)range andColor:(UIColor *)vaColor
{
    if (label) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text?label.text:@""];
        [str addAttribute:NSFontAttributeName value:font range:range];
        [str addAttribute:NSForegroundColorAttributeName value:vaColor range:range];
        label.attributedText = str;
    }
}

/**
 下载单张图片
 
 @param urlString 图片网络地址
 @param success 图片
 */
+ (void)downloadImageWithURLString:(NSString *)urlString success:(void (^)(UIImage *))success
{
    NSURL *url = [NSURL URLWithString:urlString];
    [[SDImageCache sharedImageCache] diskImageExistsWithKey:url.absoluteString completion:^(BOOL isInCache) {
        if (isInCache) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url.absoluteString];
            if (image && success) {
                success(image);
            }
        }
        else
        {
            [SDWebImageManager.sharedManager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (image && success) {
                    success(image);
                }
            }];
        }
    }];
}

/**
 下载图片组

 @param urlStrings 图片网络地址
 @param success 图片
 */
+ (void)downloadImageWithURLStrings:(NSArray *)urlStrings success:(void (^)(NSMutableArray<UIImage *> *images))success
{
    __block NSInteger index = 0;
    NSMutableArray *images = [NSMutableArray array];
    for (NSString *urlString in urlStrings) {        
        [self downloadImageWithURLString:urlString success:^(UIImage *image) {
            index ++;
            [images addObject:image];
            if (success && urlStrings.count == index) {
                success(images);
            }
        }];
    }
}

/**
 设备是否存在，耳麦，耳机等

 @return return value description
 */
+ (BOOL)isHeadsetPluggedIn
{
    AVAudioSessionRouteDescription *route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription *desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            return YES;
        }
        else if([[desc portType] isEqualToString:AVAudioSessionPortHeadsetMic]) {
            return YES;
        } else {
            continue;
        }
    }
    return NO;
}
@end
