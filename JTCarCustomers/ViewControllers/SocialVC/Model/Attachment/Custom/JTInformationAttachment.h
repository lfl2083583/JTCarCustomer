//
//  JTInformationAttachment.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTCustomAttachmentDefines.h"

@interface JTInformationAttachment : NSObject <NIMCustomAttachment, JTSessionContentConfig>

@property (nonatomic, copy) NSString *informationId;
@property (nonatomic, copy) NSString *h5Url;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;

- (instancetype)initWithInformationId:(NSString *)informationId
                                h5Url:(NSString *)h5Url
                             coverUrl:(NSString *)coverUrl
                                title:(NSString *)title
                              content:(NSString *)content;

@end
