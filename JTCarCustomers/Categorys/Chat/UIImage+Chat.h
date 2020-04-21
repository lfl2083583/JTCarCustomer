//
//  UIImage+Chat.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (NIMKit)

+ (CGSize)jt_sizeWithImageOriginSize:(CGSize)originSize
                             minSize:(CGSize)imageMinSize
                             maxSize:(CGSize)imageMaxSiz;

+ (UIImage *)jt_imageInKit:(NSString *)imageName;

+ (UIImage *)jt_emoticonInKit:(NSString *)imageName;
@end
