//
//  JTMessageMaker.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTMessageMaker.h"
#import "JTImageAttachment.h"
#import "JTVideoAttachment.h"
#import "JTExpressionAttachment.h"
#import "JTCardAttachment.h"
#import "JTFunsAttachment.h"
#import "JTGroupAttachment.h"
#import "JTInformationAttachment.h"
#import "JTActivityAttachment.h"
#import "JTShopAttachment.h"
#import "JTTeamOwnerTipAttachment.h"

@implementation JTMessageMaker

+ (NIMMessage *)messageWithText:(NSString *_Nullable)text
{
    NIMMessage *textMessage = [[NIMMessage alloc] init];
    textMessage.text        = text;
    return textMessage;
}

+ (NIMMessage *)messageWithImage:(UIImage *_Nullable)image
{
    NIMImageObject *imageObject = [[NIMImageObject alloc] initWithImage:image];
    NIMImageOption *option  = [[NIMImageOption alloc] init];
    option.compressQuality  = 0.7;
    imageObject.option      = option;
    return [self generateImageMessage:imageObject];
}

+ (NIMMessage *)generateImageMessage:(NIMImageObject *_Nullable)imageObject
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *dateString     = [dateFormatter stringFromDate:[NSDate date]];
    imageObject.displayName  = [NSString stringWithFormat:@"图片发送于%@", dateString];
    NIMMessage *message      = [[NIMMessage alloc] init];
    message.messageObject    = imageObject;
    message.apnsContent      = @"发来了一张图片";
    return message;
}

+ (NIMMessage *_Nullable)messageWithImageUrl:(NSString *)imageUrl
                              imageThumbnail:(NSString *)imageThumbnail
                                  imageWidth:(NSString *)imageWidth
                                 imageHeight:(NSString *)imageHeight;
{
    JTImageAttachment *attachment = [[JTImageAttachment alloc] initWithImageUrl:imageUrl
                                                                 imageThumbnail:imageThumbnail
                                                                     imageWidth:imageWidth
                                                                    imageHeight:imageHeight];
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent               = @"发来了一张图片";
    return message;
}

+ (NIMMessage *)messageWithAudio:(NSString *_Nullable)filePath
{
    NIMAudioObject *audioObject = [[NIMAudioObject alloc] initWithSourcePath:filePath];
    NIMMessage *message   = [[NIMMessage alloc] init];
    message.messageObject = audioObject;
    message.text          = @"发来了一段语音";
    return message;
}

+ (NIMMessage *)messageWithVideo:(NSString *_Nullable)filePath
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString        = [dateFormatter stringFromDate:[NSDate date]];
    NIMVideoObject *videoObject = [[NIMVideoObject alloc] initWithSourcePath:filePath];
    videoObject.displayName     = [NSString stringWithFormat:@"视频发送于%@", dateString];
    NIMMessage *message         = [[NIMMessage alloc] init];
    message.messageObject       = videoObject;
    message.apnsContent         = @"发来了一段视频";
    return message;
}

+ (NIMMessage *_Nullable)messageWithVideoUrl:(NSString *_Nullable)videoUrl
                               videoCoverUrl:(NSString *_Nullable)videoCoverUrl
                                  videoWidth:(NSString *_Nullable)videoWidth
                                 videoHeight:(NSString *_Nullable)videoHeight
{
    JTVideoAttachment *attachment = [[JTVideoAttachment alloc] initWithVideoUrl:videoUrl
                                                                  videoCoverUrl:videoCoverUrl
                                                                     videoWidth:videoWidth
                                                                    videoHeight:videoHeight];
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent               = @"发来了一段视频";
    return message;
}

+ (NIMMessage *)messageWithLocation:(double)latitude
                          longitude:(double)longitude
                              title:(nullable NSString *)title
{
    NIMLocationObject *locationObject = [[NIMLocationObject alloc] initWithLatitude:latitude
                                                                          longitude:longitude
                                                                              title:title];
    NIMMessage *message               = [[NIMMessage alloc] init];
    message.messageObject             = locationObject;
    message.apnsContent = @"发来了一条位置信息";
    return message;
}

+ (NIMMessage *_Nullable)messageWithExpression:(NSString *_Nullable)expressionID
                                expressionName:(NSString *_Nullable)expressionName
                                 expressionUrl:(NSString *_Nullable)expressionUrl
                           expressionThumbnail:(NSString *_Nullable)expressionThumbnail
                               expressionWidth:(NSString *_Nullable)expressionWidth
                              expressionHeight:(NSString *_Nullable)expressionHeight
{
    JTExpressionAttachment *attachment = [[JTExpressionAttachment alloc] initWithExpressionID:expressionID
                                                                               expressionName:expressionName
                                                                                expressionUrl:expressionUrl
                                                                          expressionThumbnail:expressionThumbnail
                                                                              expressionWidth:expressionWidth
                                                                             expressionHeight:expressionHeight];
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = (expressionName && expressionName.length > 0) ? [NSString stringWithFormat:@"[%@]", expressionName] : @"[贴图]";
    return message;
}

+ (NIMMessage *)messageWithTip:(NSString *_Nullable)tip
{
    NIMMessage *message        = [[NIMMessage alloc] init];
    NIMTipObject *tipObject    = [[NIMTipObject alloc] init];
    message.messageObject      = tipObject;
    message.text               = tip;
    NIMMessageSetting *setting = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled        = NO;
    setting.shouldBeCounted    = NO;
    message.setting            = setting;
    return message;
}


+ (NIMMessage *_Nullable)messageWithCard:(NSString *_Nullable)userID
{
    NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:userID];
    JTCardAttachment *attachment = [[JTCardAttachment alloc] initWithUserId:[JTUserInfoHandle showUserId:user]
                                                                   userName:user.userInfo.nickName
                                                                 userNumber:@""
                                                            avatarUrlString:[[user.userInfo.avatarUrl componentsSeparatedByString:@"?"] firstObject]];
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"发来了一张用户名片";
    return message;
}

+ (NIMMessage *_Nullable)messageWithFuns:(NSString *_Nullable)userID
                                yunxinId:(NSString *_Nullable)yunxinId
                                    type:(NSInteger)type
                                    time:(NSString *_Nullable)time
{
    JTFunsAttachment *attachment = [[JTFunsAttachment alloc] initWithUserId:userID
                                                                   yunxinId:yunxinId
                                                                       type:type
                                                                       time:time];
    NIMMessage *message = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    NIMMessageSetting *setting        = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled               = NO;
    setting.shouldBeCounted           = NO;
    message.setting                   = setting;
    return message;
}

+ (NIMMessage *_Nullable)messageWithGroup:(NSString *_Nullable)groupId
                                     name:(NSString *_Nullable)name
                                     icon:(NSString *_Nullable)icon
{
    JTGroupAttachment *attachment = [[JTGroupAttachment alloc] initWithGroupId:groupId
                                                                          name:name
                                                                          icon:icon];
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"发来了一张群名片";
    return message;
}

+ (NIMMessage *_Nullable)messageWithInformation:(NSString *_Nullable)informationId
                                          h5Url:(NSString *_Nullable)h5Url
                                       coverUrl:(NSString *_Nullable)coverUrl
                                          title:(NSString *_Nullable)title
                                        content:(NSString *_Nullable)content
{
    JTInformationAttachment *attachment = [[JTInformationAttachment alloc] initWithInformationId:informationId
                                                                                           h5Url:h5Url
                                                                                        coverUrl:coverUrl
                                                                                           title:title
                                                                                         content:content];
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"发来了一张资讯名片";
    return message;
}

+ (NIMMessage *_Nullable)messageWithActivity:(NSString *_Nullable)activityId
                                    coverUrl:(NSString *_Nullable)coverUrl
                                       theme:(NSString *_Nullable)theme
                                        time:(NSString *_Nullable)time
                                     address:(NSString *_Nullable)address
{
    JTActivityAttachment *attachment = [[JTActivityAttachment alloc] initWithActivityId:activityId
                                                                               coverUrl:coverUrl
                                                                                  theme:theme
                                                                                   time:time
                                                                                address:address];
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"发来了一张活动名片";
    return message;
}

+ (NIMMessage *_Nullable)messageWithShop:(NSString *_Nullable)shopId
                                coverUrl:(NSString *_Nullable)coverUrl
                                    name:(NSString *_Nullable)name
                                   score:(NSString *_Nullable)score
                                    time:(NSString *_Nullable)time
                                 address:(NSString *_Nullable)address
{
    JTShopAttachment *attachment = [[JTShopAttachment alloc] initWithShopId:shopId
                                                                   coverUrl:coverUrl
                                                                       name:name
                                                                      score:score
                                                                       time:time
                                                                    address:address];
    NIMMessage *message               = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    message.apnsContent = @"发来了一张店铺名片";
    return message;
}

+ (NIMMessage *_Nullable)messageWithTeamOwnerTip:(NSString *_Nullable)text
{
    JTTeamOwnerTipAttachment *attachment = [[JTTeamOwnerTipAttachment alloc] initWithText:text];
    NIMMessage *message = [[NIMMessage alloc] init];
    NIMCustomObject *customObject     = [[NIMCustomObject alloc] init];
    customObject.attachment           = attachment;
    message.messageObject             = customObject;
    NIMMessageSetting *setting        = [[NIMMessageSetting alloc] init];
    setting.apnsEnabled               = NO;
    setting.shouldBeCounted           = NO;
    message.setting                   = setting;
    return message;
}

+ (void)messageWithImageUrl:(NSString *_Nullable)imageUrl
                   complete:(void (^_Nullable)(NIMMessage *_Nullable message))complete
                    failure:(void (^_Nullable)(id _Nullable error))failure
{
    __weak typeof(self) weakself = self;
    [self getNetworkImageUrl:imageUrl success:^(UIImage * _Nullable image) {
        complete([weakself messageWithImage:image]);
    } failure:^(id  _Nullable error) {
        failure(error);
    }];
}

+ (void)messageWithVideoUrl:(NSString *_Nullable)videoUrl
              videoCoverUrl:(NSString *_Nullable)videoCoverUrl
                   complete:(void (^_Nullable)(NIMMessage *_Nullable message))complete
                    failure:(void (^_Nullable)(id _Nullable error))failure
{
    __weak typeof(self) weakself = self;
    [self getNetworkImageUrl:videoCoverUrl success:^(UIImage * _Nullable image) {
        NSString *videoWidth = [NSString stringWithFormat:@"%f", image.size.width];
        NSString *videoHeight = [NSString stringWithFormat:@"%f", image.size.height];
        complete([weakself messageWithVideoUrl:videoUrl videoCoverUrl:videoCoverUrl videoWidth:videoWidth videoHeight:videoHeight]);
    } failure:^(id  _Nullable error) {
        failure(error);
    }];
}

+ (void)messageWithExpressionUrl:(NSString *_Nullable)expressionUrl
             expressionThumbnail:(NSString *_Nullable)expressionThumbnail
                  expressionName:(NSString *_Nullable)expressionName
                        complete:(void (^_Nullable)(NIMMessage *_Nullable message))complete
                         failure:(void (^_Nullable)(id _Nullable error))failure
{
    __weak typeof(self) weakself = self;
    [self getNetworkImageUrl:expressionUrl success:^(UIImage * _Nullable image) {
        NSString *expressionWidth = [NSString stringWithFormat:@"%f", image.size.width];
        NSString *expressionHeight = [NSString stringWithFormat:@"%f", image.size.height];
        complete([weakself messageWithExpression:@"" expressionName:expressionName expressionUrl:expressionUrl expressionThumbnail:expressionThumbnail expressionWidth:expressionWidth expressionHeight:expressionHeight]);
    } failure:^(id  _Nullable error) {
        failure(error);
    }];
}

+ (void)getNetworkImageUrl:(NSString *)imageUrl
                   success:(void (^_Nullable)(UIImage *_Nullable image))success
                   failure:(void (^_Nullable)(id _Nullable error))failure
{
    NSURL *URL = [NSURL URLWithString:imageUrl];
    [[SDImageCache sharedImageCache] diskImageExistsWithKey:URL.absoluteString completion:^(BOOL isInCache) {
        if (!isInCache) {
            [SDWebImageManager.sharedManager loadImageWithURL:URL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if (error) {
                    if (failure) {
                        failure(error);
                    }
                }
                else
                {
                    if (success) {
                        success(image);
                    }
                }
            }];
        }
        else
        {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:URL.absoluteString];
            if (image) {
                success(image);
            }
            else
            {
                failure(nil);
            }
        }
    }];
}

@end
