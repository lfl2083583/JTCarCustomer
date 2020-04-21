//
//  ImageDisplayTool.h
//  GCHCustomerMall
//
//  Created by 观潮汇 on 2016/11/5.
//  Copyright © 2016年 观潮汇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"

typedef NS_ENUM(NSInteger, JTImageDisplayType)
{
    JTImageDisplayTypeSession = 1,    // 会话
};

@interface ImageDisplayTool : NSObject <MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (weak, nonatomic) UIViewController *rootViewController;

@property (strong, nonatomic) NSArray *dataArray;
@property (assign, nonatomic) JTImageDisplayType imageDisplayType;

+ (instancetype)shareImageDisplayTool;
- (void)showInViewController:(UIViewController *)viewController dataArray:(NSArray *)dataArray currentPhotoIndex:(NSInteger)currentPhotoIndex imageDisplayType:(JTImageDisplayType)imageDisplayType;

@end
