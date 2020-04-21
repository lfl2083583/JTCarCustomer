//
//  JTVideoAttachment.m
//  QTNewIMApp
//
//  Created by apple on 2017/4/13.
//  Copyright © 2017年 z. All rights reserved.
//

#import "JTVideoAttachment.h"

@implementation JTVideoAttachment

- (instancetype)initWithVideoUrl:(NSString *)videoUrl videoCoverUrl:(NSString *)videoCoverUrl videoWidth:(NSString *)videoWidth videoHeight:(NSString *)videoHeight
{
    self = [super init];
    if (self) {
        _videoUrl = videoUrl;
        _videoCoverUrl = videoCoverUrl;
        _videoWidth = videoWidth;
        _videoHeight = videoHeight;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeVideo ),
                           CMData : @{ CMCustomVideoUrl : self.videoUrl?self.videoUrl : @"",
                                       CMCustomVideoCoverUrl : self.videoCoverUrl?self.videoCoverUrl : @"",
                                       CMCustomVideoWidth : self.videoWidth?self.videoWidth : @"",
                                       CMCustomVideoHeight : self.videoHeight?self.videoHeight : @""
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
    CGFloat attachmentImageMinWidth  = 40;
    CGFloat attachmentImageMinHeight = 40;
    CGFloat attachmemtImageMaxWidth  = 150*[UIScreen mainScreen].bounds.size.width/375;
    CGFloat attachmentImageMaxHeight = 150*[UIScreen mainScreen].bounds.size.width/375;
    
    CGSize imageSize;
    if (self.videoWidth && self.videoWidth.length > 0 && self.videoHeight && self.videoHeight.length > 0) {
        imageSize = CGSizeMake([self.videoWidth floatValue], [self.videoHeight floatValue]);
    }
    else
    {
        UIImage *image = [UIImage imageWithContentsOfFile:self.videoCoverUrl];
        imageSize = image ? image.size : CGSizeZero;
    }
    CGSize turnImageSize = [UIImage jt_sizeWithImageOriginSize:imageSize
                                                       minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                                       maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
    return CGSizeMake(turnImageSize.width+4, turnImageSize.height+4);
}

@end
