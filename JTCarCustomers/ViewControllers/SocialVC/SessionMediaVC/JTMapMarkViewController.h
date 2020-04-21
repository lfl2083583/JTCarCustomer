//
//  JTMapMarkViewController.h
//  JTSocial
//
//  Created by apple on 2017/7/15.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTMapMarkType) {
    JTMapMarkTypeMessage,
    JTMapMarkTypeCollection,
    JTMapMarkTypeNone
};

@interface JTMapMarkViewController : UIViewController

// 用于消息打开地图
- (instancetype _Nonnull)initWithMessage:(NIMMessage *_Nonnull)message;
// 用于收藏打开地图
- (instancetype _Nullable)initWithCollection:(NSString *)collectionID
                                    latitude:(double)latitude
                                   longitude:(double)longitude
                                       title:(nullable NSString *)title
                                    subTitle:(nullable NSString *)subTitle;
// 用于其他打开地图
- (instancetype _Nullable)initWithLocation:(double)latitude
                                 longitude:(double)longitude
                                     title:(nullable NSString *)title
                                  subTitle:(nullable NSString *)subTitle;


@end
