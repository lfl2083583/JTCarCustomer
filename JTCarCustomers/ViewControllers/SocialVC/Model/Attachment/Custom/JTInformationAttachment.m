//
//  JTInformationAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInformationAttachment.h"

@implementation JTInformationAttachment

- (instancetype)initWithInformationId:(NSString *)informationId
                                h5Url:(NSString *)h5Url
                             coverUrl:(NSString *)coverUrl
                                title:(NSString *)title
                              content:(NSString *)content
{
    self = [super init];
    if (self) {
        _informationId = informationId;
        _h5Url = h5Url;
        _coverUrl = coverUrl;
        _title = title;
        _content = content;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeInformation ),
                           CMData : @{ CMCustomInformationID : self.informationId?self.informationId : @"",
                                       CMCustomInformationH5Url : self.h5Url?self.h5Url : @"",
                                       CMCustomInformationCoverUrl : self.coverUrl?self.coverUrl : @"",
                                       CMCustomInformationTitle : self.title?self.title : @"",
                                       CMCustomInformationContent : self.content?self.content : @"",
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
    return CGSizeMake(JTBubbleMaxWidth, 130);
}

- (NSString *)contentBubbleImage:(NIMMessage *)message
{
    return message.isOutgoingMsg ? @"icon_sender_node_white_normal " : @"icon_receiver_node_normal";
}
@end
