//
//  JTTeamOperationAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTeamOperationAttachment.h"

@implementation JTTeamOperationAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeTeamOperation ),
                           CMData : @{ CMTeamOperationActionType : self.actionType?self.actionType : @"",
                                       CMTeamOperationSessionId : self.sessionId?self.sessionId : @"",
                                       CMTeamOperationUserInfo : self.userInfo?self.userInfo : @{},
                                       CMTeamOperationUserList : self.userList?self.userList : @[],
                                       CMTeamOperationMessage : self.message?self.message : @"",
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

- (NSString *)teamOperationText
{
    if (!_teamOperationText || _teamOperationText.length == 0) {
        _teamOperationText = [self.teamOperationOperationInfo objectForKey:@"text"];
    }
    return _teamOperationText;
}

- (NSMutableAttributedString *)teamOperationAttributedString
{
    if (!_teamOperationAttributedString) {
        _teamOperationAttributedString = [self.teamOperationOperationInfo objectForKey:@"attributed"];
    }
    return _teamOperationAttributedString;
}

- (NSMutableArray *)teamOperationLinks
{
    if (!_teamOperationLinks) {
        _teamOperationLinks = [self.teamOperationOperationInfo objectForKey:@"links"];
    }
    return _teamOperationLinks;
}

- (NSDictionary *)teamOperationOperationInfo
{
    if (!_teamOperationOperationInfo) {
        
        NSString *leftText = @"", *rightText = @"", *allText = @"";
        NIMSession *session = [NIMSession session:self.sessionId type:NIMSessionTypeTeam];
        
        if ([[self.userInfo objectForKey:@"accid"] isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            
            leftText = @"你";
        }
        else
        {
            leftText = [JTUserInfoHandle showNick:[self.userInfo objectForKey:@"accid"] inSession:session];
        }
        
        if ([self.userList isKindOfClass:[NSArray class]] &&  self.userList.count > 0) {
            
            if ([[self.userList firstObject] isKindOfClass:[NSDictionary class]]) {
                
                if ([[[self.userList firstObject] objectForKey:@"accid"] isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
                    
                    rightText = @"你";
                }
                else
                {
                    rightText = [JTUserInfoHandle showNick:[[self.userList firstObject] objectForKey:@"accid"] inSession:session];
                }
            }
        }
        
        if (self.userList.count > 1) {
            rightText = [rightText stringByAppendingString:[NSString stringWithFormat:@"等%lu人", (unsigned long)self.userList.count]];
        }
        
        switch ([self.actionType integerValue]) {
            case TeamOperationActionTypeNormal:
            {
                allText = @"群主创建群";
            }
                break;
            case TeamOperationActionTypeInvite:
            {
                allText = [NSString stringWithFormat:@"%@邀请%@加入了本群", leftText, rightText];
            }
                break;
            case TeamOperationActionTypeCodeEnter:
            {
                allText = [NSString stringWithFormat:@"%@加入了本群", rightText];
            }
                break;
            case TeamOperationActionTypeActivityEnter:
            {
                allText = [NSString stringWithFormat:@"%@加入了本群", leftText];
            }
                break;
            case TeamOperationActionTypeNormalEnter:
            {
                allText = [NSString stringWithFormat:@"%@加入了本群", leftText];
            }
                break;
            case TeamOperationActionTypeAgainEnter:
            {
                allText = [NSString stringWithFormat:@"%@加入了本群", leftText];
            }
                break;
                
                
            case TeamOperationActionTypeKick:
            {
                allText = [NSString stringWithFormat:@"%@将%@移出了群聊", leftText, rightText];
            }
                break;
            case TeamOperationActionTypeMute:
            {
                allText = [NSString stringWithFormat:@"%@将%@设置了禁止发言", leftText, rightText];
            }
                break;
            case TeamOperationActionTypeCancelMute:
            {
                allText = [NSString stringWithFormat:@"%@将%@解除禁言", leftText, rightText];
            }
                break;
            case TeamOperationActionTypeQuit:
            {
                allText = [NSString stringWithFormat:@"%@退出群", leftText];
            }
                break;
            case TeamOperationActionTypeModifyPower:
            {
                allText = [NSString stringWithFormat:@"%@将%@设置了群权限", leftText, rightText];
            }
                break;
            case TeamOperationActionTypeTeamModel:
            {
                allText = [NSString stringWithFormat:@"%@开启了%@", [leftText isEqualToString:@"你"]?leftText:@"群主", self.message];
            }
                break;
            case TeamOperationActionTypeTransfer:
            {
                allText = [NSString stringWithFormat:@"%@将群转让给%@", leftText, rightText];
            }
                break;
                
            default:
                break;
        }
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allText];
        NSMutableArray *links = [NSMutableArray array];
        [attributedString addAttribute:NSForegroundColorAttributeName value:WhiteColor range:NSMakeRange(0, allText.length)];
        [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(-3) range:NSMakeRange(0, allText.length)];
        if (leftText.length > 0 && ![leftText isEqualToString:@"你"]) {
            NSRange range = [allText rangeOfString:leftText];
            [attributedString addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
            [links addObject:@{@"value": [self.userInfo objectForKey:@"accid"], @"range": [NSValue valueWithRange:range]}];
        }
        if (rightText.length > 0 && ![rightText isEqualToString:@"你"]) {
            NSRange range = [allText rangeOfString:rightText];
            [attributedString addAttribute:NSForegroundColorAttributeName value:BlueLeverColor1 range:range];
            [links addObject:@{@"value": [[self.userList firstObject] objectForKey:@"accid"], @"range": [NSValue valueWithRange:range]}];
        }
        _teamOperationOperationInfo = @{@"text": allText, @"attributed": attributedString, @"links": links};
    }
    return _teamOperationOperationInfo;
}

- (CGSize)contentSize:(NIMMessage *)message
{
    NSMutableAttributedString *attributedString = [self contenText:message];
    CGSize textSize = [Utility getTextString:attributedString.string textFont:Font(JTTipTextFont) frameWidth:(App_Frame_Width-40) attributedString:attributedString];
    return CGSizeMake(textSize.width+28, textSize.height+6);
}

- (NSMutableAttributedString *)contenText:(NIMMessage *)message
{
    NSMutableAttributedString *attributedString = self.teamOperationAttributedString;
    [attributedString addAttribute:NSFontAttributeName value:Font(JTTipTextFont) range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (NSArray *)contentLinks:(NIMMessage *)message
{
    return self.teamOperationLinks;
}

@end
