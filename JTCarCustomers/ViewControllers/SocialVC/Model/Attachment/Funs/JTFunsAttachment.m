//
//  JTFunsAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTFunsAttachment.h"

@implementation JTFunsAttachment

- (instancetype)initWithUserId:(NSString *)userId
                      yunxinId:(NSString *)yunxinId
                          type:(NSInteger)type
                          time:(NSString *)time
{
    self = [super init];
    if (self) {
        _userId = userId;
        _yunxinId = yunxinId;
        _type = type;
        _time = time;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageFuns ),
                           CMData : @{ CMFunsUserId : self.userId?self.userId : @"",
                                       CMFunsYunXinId : self.yunxinId?self.yunxinId : @"",
                                       CMFunsType : @(self.type),
                                       CMFunsTime : self.time?self.time : @""
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

- (NSString *)funsText
{
    if (!_funsText || _funsText.length == 0) {
        _funsText = [[self funsInfo] objectForKey:@"text"];
    }
    return _funsText;
}

- (NSMutableAttributedString *)funsAttributedString
{
    if (!_funsAttributedString) {
        _funsAttributedString = [[self funsInfo] objectForKey:@"attributed"];
    }
    return _funsAttributedString;
}

- (NSDictionary *)funsInfo
{
    NSString *text = @"";
    if (self.type == 0) {
        text = [[NSString alloc] initWithFormat:@"%@关注了你", [JTUserInfoHandle showNick:self.yunxinId]];
    }
    else
    {
        text = [[NSString alloc] initWithFormat:@"你关注了%@", [JTUserInfoHandle showNick:self.yunxinId]];
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    return @{@"text": text, @"attributed": attributedString};
}

- (CGSize)contentSize:(NIMMessage *)message
{
    NSMutableAttributedString *attributedString = [self contenText:message];
    CGSize textSize = [Utility getTextString:attributedString.string textFont:Font(JTMessageTextFont) frameWidth:(JTBubbleMaxWidth-28) attributedString:attributedString];
    return CGSizeMake(textSize.width+28, textSize.height+20);
}

- (NSMutableAttributedString *)contenText:(NIMMessage *)message
{
    NSMutableAttributedString *attributedString = self.funsAttributedString;
    [attributedString addAttribute:NSFontAttributeName value:Font(JTMessageTextFont) range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

@end
