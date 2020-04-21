//
//  JTSessionConfig.m
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "JTSessionConfig.h"
#import "JTInputBarItemType.h"
#import "JTMediaItem.h"
#import "UIImage+Chat.h"

@interface JTSessionConfig ()

@end

@implementation JTSessionConfig

- (instancetype)initWithSession:(NIMSession *)session
{
    self = [super init];
    if (self) {
        _session = session;
    }
    return self;
}

- (NSArray<NSNumber *> *)inputBarItemTypes
{
    if (self.session.sessionType == NIMSessionTypeP2P && [JTUserInfoHandle showAppUserType:[[NIMSDK sharedSDK].userManager userInfo:self.session.sessionId]] == JTAppUserTypeTalent) {
        return @[@(JTInputBarItemTypeReward),
                 @(JTInputBarItemTypeAlbum),
                 @(JTInputBarItemTypeCamera),
                 @(JTInputBarItemTypeExpression)
                 ];
    }
    else
    {
        return @[@(JTInputBarItemTypeVoice),
                 @(JTInputBarItemTypeAlbum),
                 @(JTInputBarItemTypeCamera),
                 @(JTInputBarItemTypeBonus),
                 @(JTInputBarItemTypeExpression),
                 @(JTInputBarItemTypeMore)
                 ];
    }
}

- (NSArray<JTMediaItem *> *)mediaItems
{
    JTMediaItem *bonusItem =      [JTMediaItem item:@"onTapMediaItemBonus:"
                                          normalImage:[UIImage jt_imageInKit:@"icon_im_bonus"]
                                        selectedImage:[UIImage jt_imageInKit:@"icon_im_bonus"]
                                                title:@"红包"];
    
    JTMediaItem *cardItem =       [JTMediaItem item:@"onTapMediaItemCard:"
                                        normalImage:[UIImage jt_imageInKit:@"icon_im_card"]
                                      selectedImage:[UIImage jt_imageInKit:@"icon_im_card"]
                                              title:@"个人名片"];
    
    JTMediaItem *collectionItem = [JTMediaItem item:@"onTapMediaItemCollection:"
                                        normalImage:[UIImage jt_imageInKit:@"icom_im_collect"]
                                      selectedImage:[UIImage jt_imageInKit:@"icom_im_collect"]
                                              title:@"收藏"];
    
    JTMediaItem *videoChatItem =  [JTMediaItem item:@"onTapMediaItemVideoChat:"
                                        normalImage:[UIImage jt_imageInKit:@"icom_im_videoChat"]
                                      selectedImage:[UIImage jt_imageInKit:@"icom_im_videoChat"]
                                              title:@"视频聊天"];
    
    JTMediaItem *locationItem =   [JTMediaItem item:@"onTapMediaItemLocation:"
                                        normalImage:[UIImage jt_imageInKit:@"icom_im_location"]
                                      selectedImage:[UIImage jt_imageInKit:@"icom_im_location"]
                                              title:@"位置"];
    
    if (self.session.sessionType == NIMSessionTypeP2P) {
        return @[bonusItem, cardItem, collectionItem, videoChatItem, locationItem];
    }
    else
    {
        return @[bonusItem, cardItem, collectionItem, locationItem];
    }
}

- (BOOL)shouldHandleReceipt {
    return YES;
}

- (BOOL)shouldHandleReceiptForMessage:(NIMMessage *)message
{
    //文字，语音，图片，视频，文件，地址位置和自定义消息都支持已读回执，其他的不支持
    NIMMessageType type = message.messageType;
    return (type == NIMMessageTypeText || type == NIMMessageTypeAudio || type == NIMMessageTypeImage || type == NIMMessageTypeVideo || type == NIMMessageTypeFile ||  type == NIMMessageTypeLocation || type == NIMMessageTypeCustom);
}

- (BOOL)isFilterMessage:(NIMMessage *)message
{
//    if (message.messageType == NIMMessageTypeNotification) {
//        NIMNotificationObject *object = (NIMNotificationObject *)message.messageObject;
//        if (object.notificationType == NIMNotificationTypeTeam) {
//            NIMTeamNotificationContent *content = (NIMTeamNotificationContent *)object.content;
//            if (content.operationType == NIMTeamOperationTypeUpdate) {
//                id attachment = [content attachment];
//                if ([attachment isKindOfClass:[NIMUpdateTeamInfoAttachment class]]) {
//                    NIMUpdateTeamInfoAttachment *teamAttachment = (NIMUpdateTeamInfoAttachment *)attachment;
//                    if ([teamAttachment.values count] == 1) {
//                        NIMTeamUpdateTag tag = [[[teamAttachment.values allKeys] firstObject] integerValue];
//                        if (tag == NIMTeamUpdateTagAnouncement) {
//                            return YES;
//                        }
//                    }
//                }
//            }
//        }
//    }
    return NO;
}
@end
