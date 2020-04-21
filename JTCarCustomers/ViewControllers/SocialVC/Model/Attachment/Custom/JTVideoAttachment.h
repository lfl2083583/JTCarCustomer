//
//  JTVideoAttachment.h
//  QTNewIMApp
//
//  Created by apple on 2017/4/13.
//  Copyright © 2017年 z. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTVideoAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (copy, nonatomic) NSString *videoPath;
@property (copy, nonatomic) NSString *videoUrl;
@property (copy, nonatomic) NSString *videoCoverUrl;
@property (copy, nonatomic) NSString *videoWidth;
@property (copy, nonatomic) NSString *videoHeight;

- (instancetype)initWithVideoUrl:(NSString *)videoUrl
                   videoCoverUrl:(NSString *)videoCoverUrl
                      videoWidth:(NSString *)videoWidth
                     videoHeight:(NSString *)videoHeight;
@end
