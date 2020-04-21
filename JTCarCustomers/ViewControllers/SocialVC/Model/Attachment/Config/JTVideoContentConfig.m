//
//  JTVideoContentConfig.m
//  JTSocial
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTVideoContentConfig.h"

@implementation JTVideoContentConfig

- (CGSize)contentSize:(NIMMessage *)message
{
    NIMVideoObject *videoContent = (NIMVideoObject *)[message messageObject];
    NSAssert([videoContent isKindOfClass:[NIMVideoObject class]], @"message should be audio");
    
    CGFloat attachmentImageMinWidth  = 40;
    CGFloat attachmentImageMinHeight = 40;
    CGFloat attachmemtImageMaxWidth  = 150*[UIScreen mainScreen].bounds.size.width/375;
    CGFloat attachmentImageMaxHeight = 150*[UIScreen mainScreen].bounds.size.width/375;
    
    
    CGSize imageSize;
    if (!CGSizeEqualToSize(videoContent.coverSize, CGSizeZero)) {
        imageSize = videoContent.coverSize;
    }
    else
    {
        UIImage *image = [UIImage imageWithContentsOfFile:videoContent.coverPath];
        imageSize = image ? image.size : CGSizeZero;
    }
    CGSize turnImageSize = [UIImage jt_sizeWithImageOriginSize:imageSize
                                                       minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                                       maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
    return CGSizeMake(turnImageSize.width, turnImageSize.height);
}

@end
