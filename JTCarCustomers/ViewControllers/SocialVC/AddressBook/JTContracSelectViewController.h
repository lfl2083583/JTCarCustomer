//
//  JTContracSelectViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTContactConfig.h"
#import "BaseRefreshViewController.h"

typedef void(^SelectUserFinishBlock)(NSArray *yunxinIDs, NSArray *userIDs);
typedef void(^ZT_ContractSelectBlock)(NSArray *yunxinIDs, NSArray *userIDs, NSString *content);

@interface JTContracSelectViewController : BaseRefreshViewController

@property (nonatomic, strong, readonly) id<JTContactConfig> config;
@property (nonatomic, strong, readonly) NIMMessage *message;
@property (nonatomic, copy) SelectUserFinishBlock finshBlock;
@property (nonatomic, copy) ZT_ContractSelectBlock callBack;


/**
 初始化方法
 
 @param config 联系人选择器配置
 @return return value description
 */
- (instancetype)initWithConfig:(id<JTContactConfig>)config;

/**
 初始化方法
 
 @param config 联系人选择器配置
 @param message 消息体
 @return return value description
 */
- (instancetype)initWithConfig:(id<JTContactConfig>)config message:(NIMMessage *)message;

@end
