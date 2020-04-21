//
//  JTExpressionTool.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kCollectionExpressionFileName @"CollectionExpressionFileName"
#define kOtherExpressionFileName      @"OtherExpressionFileName"
#define kJTExpressionKey              @"JTExpressionKey"

@interface JTExpressionTool : NSObject

@property (strong, nonatomic) NSMutableArray *collectionExpressions;
@property (strong, nonatomic) NSMutableArray *otherExpressions;

+ (instancetype)sharedManager;

/**
 同步所有表情
 
 @param success success description
 @param failure failure description
 */
- (void)synchronizationData:(void (^)(void))success
                    failure:(void (^)(void))failure;


/**
 添加单个表情
 
 @param model emoticonModel description
 @param success success description
 @param failure failure description
 */
- (void)addSingleModel:(NSDictionary *)model
               success:(void (^)(void))success
               failure:(void (^)(void))failure;

/**
 下载所有表情组
 
 @param models emoticons description
 */
- (void)downloadModels:(NSArray *)models;

/**
 下载单个表情
 
 @param model emoticonModel description
 */
- (void)downloadModel:(NSDictionary *)model;

/**
 表情到存储到本地

 @param expressions 表情数据
 @param fileName 本地文件名
 @return 是否存储成功
 */
- (BOOL)writeDocuments:(NSArray *)expressions fileName:(NSString *)fileName;

/**
 刷新收藏表情

 @param expressions 表情数据
 */
- (void)reloadCollectionExpressions:(NSArray *)expressions;

/**
 刷新其他表情

 @param expressions 表情数据
 */
- (void)reloadOtherExpressions:(NSArray *)expressions;

@end
