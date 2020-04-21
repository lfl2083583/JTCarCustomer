//
//  JTCommentInformationAttachment.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCommentInformationAttachment.h"

@implementation JTCommentInformationAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeCommentInformation ),
                           CMData : @{ CMCommentInformationAvatarUrl : self.avatarUrl?self.avatarUrl : @"",
                                       CMCommentInformationName : self.name?self.name : @"",
                                       CMCommentInformationUserID : self.userID?self.userID : @"",
                                       CMCommentInformationContent : self.content?self.content : @"",
                                       CMCommentInformationTime : @(self.time),
                                       CMCommentInformationCoverUrl : self.coverUrl?self.coverUrl : @"",
                                       CMCommentInformationUrl : self.informationUrl?self.informationUrl : @"",
                                       CMCommentInformationID : self.informationID?self.informationID : @"",
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


@end
