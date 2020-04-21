//
//  JTCollectionModel.m
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionModel.h"

@implementation JTCollectionModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"collectionType"      : @"type",
             @"collectionID"        : @"id",
             @"name"                : @"name",
             @"collectionTime"      : @"time",
             @"content"             : @"content",
             @"info"                : @"info",
             @"infoDic"             : @"user_info",
             };
}


- (NSDictionary *)contentDic
{
    if (!_contentDic) {
        _contentDic = [self.content mj_JSONObject];
    }
    return _contentDic;
}

- (NSDictionary *)infoDic
{
    if (!_infoDic) {
        _infoDic = [self.info mj_JSONObject];
    }
    return _infoDic;
}
@end
