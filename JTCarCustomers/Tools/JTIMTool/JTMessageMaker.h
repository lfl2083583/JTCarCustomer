//
//  JTMessageMaker.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTMessageMaker : NSObject


/**
 配置文字消息

 @param text 文字
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithText:(NSString *_Nullable)text;

/**
 配置图片消息
 
 @param image 图片
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithImage:(UIImage *_Nullable)image;

/**
 配置图片消息
 
 @param imageUrl 图片网络地址
 @param imageThumbnail 图片缩略图地址
 @param imageWidth 图片宽度
 @param imageHeight 图片高度
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithImageUrl:(NSString *)imageUrl
                              imageThumbnail:(NSString *)imageThumbnail
                                  imageWidth:(NSString *)imageWidth
                                 imageHeight:(NSString *)imageHeight;

/**
 配置语音消息
 
 @param filePath 语音地址
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithAudio:(NSString *_Nullable)filePath;

/**
 配置视频消息
 
 @param filePath 视频地址
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithVideo:(NSString *_Nullable)filePath;

/**
 配置视频消息
 
 @param videoUrl 视频网络地址
 @param videoCoverUrl 视频封面网络地址
 @param videoWidth 视频宽度
 @param videoHeight 视频高度
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithVideoUrl:(NSString *_Nullable)videoUrl
                               videoCoverUrl:(NSString *_Nullable)videoCoverUrl
                                  videoWidth:(NSString *_Nullable)videoWidth
                                 videoHeight:(NSString *_Nullable)videoHeight;

/**
 配置位置消息
 @param latitude  纬度
 @param longitude 经度
 @param title   地理位置描述
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithLocation:(double)latitude
                                   longitude:(double)longitude
                                       title:(nullable NSString *)title;

/**
 配置表情消息
 
 @param expressionID 表情ID
 @param expressionName 表情名称
 @param expressionUrl 表情原图远程路径
 @param expressionThumbnail 表情缩略图远程路径
 @param expressionWidth 表情宽
 @param expressionHeight 表情高
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithExpression:(NSString *_Nullable)expressionID
                                expressionName:(NSString *_Nullable)expressionName
                                 expressionUrl:(NSString *_Nullable)expressionUrl
                           expressionThumbnail:(NSString *_Nullable)expressionThumbnail
                               expressionWidth:(NSString *_Nullable)expressionWidth
                              expressionHeight:(NSString *_Nullable)expressionHeight;

/**
 配置提示消息

 @param tip 提示文章
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithTip:(NSString *_Nullable)tip;

/**
 配置名片消息

 @param userID 用户ID
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithCard:(NSString *_Nullable)userID;

/**
 配置关注消息

 @param userID 用户ID
 @param yunxinId 云信ID
 @param type 类型 （1关注者消息通知，0被关注者消息通知）
 @param time 时间
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithFuns:(NSString *_Nullable)userID
                                yunxinId:(NSString *_Nullable)yunxinId
                                    type:(NSInteger)type
                                    time:(NSString *_Nullable)time;

/**
 配置群名片消息
 
 @param groupId 群ID
 @param name 群名称
 @param icon 类型
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithGroup:(NSString *_Nullable)groupId
                                     name:(NSString *_Nullable)name
                                     icon:(NSString *_Nullable)icon;

/**
 配置资讯消息
 
 @param informationId 资讯ID
 @param coverUrl 资讯封面图片
 @param title 资讯标题
 @param content 资讯内容
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithInformation:(NSString *_Nullable)informationId
                                          h5Url:(NSString *_Nullable)h5Url
                                       coverUrl:(NSString *_Nullable)coverUrl
                                          title:(NSString *_Nullable)title
                                        content:(NSString *_Nullable)content;

/**
 配置活动消息
 
 @param activityId 活动ID
 @param coverUrl 活动封面图片
 @param theme 活动主题
 @param time 活动时间
 @param address 活动地点
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithActivity:(NSString *_Nullable)activityId
                                    coverUrl:(NSString *_Nullable)coverUrl
                                       theme:(NSString *_Nullable)theme
                                        time:(NSString *_Nullable)time
                                     address:(NSString *_Nullable)address;

/**
 配置店铺消息
 
 @param shopId 店铺ID
 @param coverUrl 店铺封面图片
 @param name 店铺名称
 @param score 店铺评分
 @param time 店铺营业时间
 @param address 店铺地址
 @return 消息体
 */
+ (NIMMessage *_Nullable)messageWithShop:(NSString *_Nullable)shopId
                                coverUrl:(NSString *_Nullable)coverUrl
                                    name:(NSString *_Nullable)name
                                   score:(NSString *_Nullable)score
                                    time:(NSString *_Nullable)time
                                 address:(NSString *_Nullable)address;

/**
 配置群主建群消息

 @param text 提示
 @return return value description
 */
+ (NIMMessage *_Nullable)messageWithTeamOwnerTip:(NSString *_Nullable)text;


/**
 发送网络图片消息
 
 @param imageUrl 图片网络地址
 @param complete 消息体
 @param failure 错误对象
 */
+ (void)messageWithImageUrl:(NSString *_Nullable)imageUrl
                   complete:(void (^_Nullable)(NIMMessage *_Nullable message))complete
                    failure:(void (^_Nullable)(id _Nullable error))failure;

/**
 发送网络视频消息
 
 @param videoUrl 视频网络地址
 @param videoCoverUrl 视频封面网络地址
 @param complete 消息体
 @param failure 错误对象
 */
+ (void)messageWithVideoUrl:(NSString *_Nullable)videoUrl
              videoCoverUrl:(NSString *_Nullable)videoCoverUrl
                   complete:(void (^_Nullable)(NIMMessage *_Nullable message))complete
                    failure:(void (^_Nullable)(id _Nullable error))failure;

/**
 发送网络表情消息
 
 @param expressionUrl 表情网络地址
 @param expressionThumbnail 表情缩略图地址
 @param expressionName 表情名称
 @param complete 消息体
 @param failure 错误对象
 */
+ (void)messageWithExpressionUrl:(NSString *_Nullable)expressionUrl
             expressionThumbnail:(NSString *_Nullable)expressionThumbnail
                  expressionName:(NSString *_Nullable)expressionName
                        complete:(void (^_Nullable)(NIMMessage *_Nullable message))complete
                         failure:(void (^_Nullable)(id _Nullable error))failure;
@end
