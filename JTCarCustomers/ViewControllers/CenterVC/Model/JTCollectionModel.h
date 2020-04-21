//
//  JTCollectionModel.h
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JTCollectionType) {
    JTCollectionTypeText = 1,             // 文字
    JTCollectionTypeAudio,                // 声音
    JTCollectionTypeExpression,           // 动态表情
    JTCollectionTypeAddress,              // 地址
    JTCollectionTypeImage,                // 图片
    JTCollectionTypeVideo,                // 小视频
    JTCollectionTypeActivity,             // 活动
    JTCollectionTypeInformation,          // 车咨询
    JTCollectionTypeShop,                 // 门店
};

@interface JTCollectionModel : NSObject

@property (assign, nonatomic) JTCollectionType collectionType;

@property (copy, nonatomic) NSString *collectionID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *collectionTime;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *info;
@property (strong, nonatomic) NSDictionary *contentDic;
@property (strong, nonatomic) NSDictionary *infoDic;
@end
