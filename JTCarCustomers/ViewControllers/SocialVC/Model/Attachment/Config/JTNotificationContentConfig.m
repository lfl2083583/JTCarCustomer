//
//  JTNotificationContentConfig.m
//  JTSocial
//
//  Created by apple on 2017/11/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTNotificationContentConfig.h"
#import "JTSessionUtil.h"

@implementation JTNotificationContentConfig

- (CGSize)contentSize:(NIMMessage *)message
{
    NSMutableAttributedString *string = [self contenText:message];
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    if (object.notificationType == NIMNotificationTypeNetCall) {
        CGSize textSize = [Utility getTextString:message.text textFont:Font(JTMessageTextFont) frameWidth:(JTBubbleMaxWidth-28) attributedString:string];
        return CGSizeMake(textSize.width+28, textSize.height+20);
    }
    else
    {
        CGSize textSize = [Utility getTextString:message.text textFont:Font(JTTipTextFont) frameWidth:(App_Frame_Width-40) attributedString:string];
        return CGSizeMake(textSize.width+28, textSize.height+6);
    }
}

- (NSMutableAttributedString *)contenText:(NIMMessage *)message
{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[JTSessionUtil messageTipContent:message]];
    NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
    if (object.notificationType == NIMNotificationTypeNetCall) {
        NIMNetCallNotificationContent *content = (NIMNetCallNotificationContent *)object.content;
        NSTextAttachment *attach = [[NSTextAttachment alloc] init];
        attach.bounds = CGRectMake(0, -4, 28, 18);
        NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
        if ([message.from isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
            attach.image = (content.callType == NIMNetCallTypeAudio)?[UIImage jt_imageInKit:@"icon_sender_audio"]:[UIImage jt_imageInKit:@"icon_sender_video"];
            [string insertAttributedString:strAtt atIndex:string.length];
        }
        else
        {
            attach.image = (content.callType == NIMNetCallTypeAudio)?[UIImage jt_imageInKit:@"icon_receiver_audio"]:[UIImage jt_imageInKit:@"icon_receiver_video"];
            [string insertAttributedString:strAtt atIndex:0];
        }
        [string addAttribute:NSFontAttributeName value:Font(JTMessageTextFont) range:NSMakeRange(0, string.length)];
    }
    else
    {
        [string addAttribute:NSFontAttributeName value:Font(JTTipTextFont) range:NSMakeRange(0, string.length)];
    }
    [string addAttribute:NSForegroundColorAttributeName value:WhiteColor range:NSMakeRange(0, string.length)];
    [string addAttribute:NSBaselineOffsetAttributeName value:@(-.5) range:NSMakeRange(0, string.length)];
    return string;
}

@end
