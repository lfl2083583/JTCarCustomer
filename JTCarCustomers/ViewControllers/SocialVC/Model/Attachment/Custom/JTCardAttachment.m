//
//  JTCardAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCardAttachment.h"

@implementation JTCardAttachment

- (instancetype)initWithUserId:(NSString *)userId
                      userName:(NSString *)userName
                    userNumber:(NSString *)userNumber
               avatarUrlString:(NSString *)avatarUrlString
{
    self = [super init];
    if (self) {
        _userId = userId;
        _userName = userName;
        _userNumber = userNumber;
        _avatarUrlString = avatarUrlString;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeCard ),
                           CMData : @{ CMCardUserId : self.userId?self.userId : @"",
                                       CMCardUserName : self.userName?self.userName : @"",
                                       CMCardUserNumber: self.userNumber?self.userNumber : @"",
                                       CMCardAvatar : self.avatarUrlString?self.avatarUrlString : @""
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

- (CGSize)contentSize:(NIMMessage *)message {
    return CGSizeMake(200, 80);
}

- (NSString *)contentBubbleImage:(NIMMessage *)message
{
    return message.isOutgoingMsg ? @"icon_sender_node_white_normal " : @"icon_receiver_node_normal";
}

@end
