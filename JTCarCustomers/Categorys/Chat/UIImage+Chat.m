//
//  UIImage+Chat.m
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import "UIImage+Chat.h"
#import "JTInputGlobal.h"

@implementation UIImage (NIMKit)

+ (CGSize)jt_sizeWithImageOriginSize:(CGSize)originSize
                             minSize:(CGSize)imageMinSize
                             maxSize:(CGSize)imageMaxSiz
{
    CGSize size;
    CGFloat imageWidth = originSize.width/2.0 ,imageHeight = originSize.height/2.0;
    NSInteger imageMinWidth = imageMinSize.width, imageMinHeight = imageMinSize.height;
    NSInteger imageMaxWidth = imageMaxSiz.width,  imageMaxHeight = imageMaxSiz.height;
    if (imageWidth > imageHeight) //宽图
    {
        size.width = MAX(MIN(imageWidth, imageMaxWidth), imageMinWidth);
        size.height = MAX(size.width*imageHeight/imageWidth, imageMinHeight);
    }
    else if(imageWidth < imageHeight) //高图
    {
        size.height = MAX(MIN(imageHeight, imageMaxHeight), imageMinHeight);
        size.width = MAX(size.height*imageWidth/imageHeight, imageMinWidth);
    }
    else //方图
    {
        size.width = MAX(MIN(imageWidth, imageMaxWidth), imageMinWidth);
        size.height = MAX(MIN(imageHeight, imageMaxHeight), imageMinHeight);
    }
    return size;
}

+ (UIImage *)jt_imageInKit:(NSString *)imageName
{
    NSString *name = [ResourceBundleName stringByAppendingPathComponent:imageName];
    return [UIImage imageNamed:name];
}

+ (UIImage *)jt_emoticonInKit:(NSString *)imageName
{
    NSString *name = [[EmoticonBundleName stringByAppendingPathComponent:JTKit_ExpressionEmoji] stringByAppendingPathComponent:imageName];
    return [UIImage imageNamed:name];
}

@end
