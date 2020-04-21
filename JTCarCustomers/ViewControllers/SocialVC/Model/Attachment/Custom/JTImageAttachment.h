//
//  JTImageAttachment.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTImageAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *imageThumbnail;
@property (nonatomic, copy) NSString *imageWidth;
@property (nonatomic, copy) NSString *imageHeight;

- (instancetype)initWithImageUrl:(NSString *)imageUrl imageThumbnail:(NSString *)imageThumbnail imageWidth:(NSString *)imageWidth imageHeight:(NSString *)imageHeight;
@end
