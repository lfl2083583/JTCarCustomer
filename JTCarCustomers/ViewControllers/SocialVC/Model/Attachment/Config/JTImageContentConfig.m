//
//  JTImageContentConfig.m
//  JTSocial
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTImageContentConfig.h"

@implementation JTImageContentConfig

- (CGSize)contentSize:(NIMMessage *)message
{
    NIMImageObject *imageObject = (NIMImageObject *)[message messageObject];
    NSAssert([imageObject isKindOfClass:[NIMImageObject class]], @"message should be image");
    
    CGFloat attachmentImageMinWidth  = 40;
    CGFloat attachmentImageMinHeight = 40;
    CGFloat attachmemtImageMaxWidth  = 150*[UIScreen mainScreen].bounds.size.width/375;
    CGFloat attachmentImageMaxHeight = 150*[UIScreen mainScreen].bounds.size.width/375;
    
    
    CGSize imageSize;
    if (!CGSizeEqualToSize(imageObject.size, CGSizeZero)) {
        imageSize = imageObject.size;
    }
    else
    {
        UIImage *image = [UIImage imageWithContentsOfFile:imageObject.thumbPath];
        imageSize = image ? image.size : CGSizeZero;
    }
    CGSize turnImageSize = [UIImage jt_sizeWithImageOriginSize:imageSize
                                                       minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                                       maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
    return CGSizeMake(turnImageSize.width, turnImageSize.height);

}
@end
