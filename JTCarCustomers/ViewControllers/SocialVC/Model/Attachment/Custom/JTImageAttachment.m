//
//  JTImageAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTImageAttachment.h"

@implementation JTImageAttachment

- (instancetype)initWithImageUrl:(NSString *)imageUrl imageThumbnail:(NSString *)imageThumbnail imageWidth:(NSString *)imageWidth imageHeight:(NSString *)imageHeight
{
    self = [super init];
    if (self) {
        _imageUrl = imageUrl;
        _imageThumbnail = imageThumbnail;
        _imageWidth = imageWidth;
        _imageHeight = imageHeight;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeImage ),
                           CMData : @{ CMCustomImageUrl : self.imageUrl?self.imageUrl : @"",
                                       CMCustomImageThumbnail : self.imageThumbnail?self.imageThumbnail : @"",
                                       CMCustomImageWidth : self.imageWidth?self.imageWidth : @"",
                                       CMCustomImageHeight : self.imageHeight?self.imageHeight : @"",
                                       }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}

- (CGSize)contentSize:(NIMMessage *)message
{
    if (self.imageWidth && self.imageWidth.length && self.imageHeight && self.imageHeight.length) {
        
        CGFloat attachmentImageMinWidth  = 40;
        CGFloat attachmentImageMinHeight = 40;
        CGFloat attachmemtImageMaxWidth  = 150*[UIScreen mainScreen].bounds.size.width/375;
        CGFloat attachmentImageMaxHeight = 150*[UIScreen mainScreen].bounds.size.width/375;
        
        CGSize imageSize = CGSizeMake([self.imageWidth floatValue], [self.imageHeight floatValue]);
        CGSize turnImageSize = [UIImage jt_sizeWithImageOriginSize:imageSize
                                                           minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                                           maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
        return CGSizeMake(turnImageSize.width+4, turnImageSize.height+4);
    }
    else
    {
        return CGSizeMake(80, 80);
    }
}

@end
