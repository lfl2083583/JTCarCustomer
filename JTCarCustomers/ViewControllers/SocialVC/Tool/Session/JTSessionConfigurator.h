//
//  JTSessionConfigurator.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JTSessionTableViewCell.h"

@class JTSessionViewController;

@interface JTSessionConfigurator : NSObject <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *items;

- (void)setup:(JTSessionViewController *)vc locationMessage:(NIMMessage *)locationMessage;


/**
 插入消息组

 @param messages 消息组
 */
- (void)insertMessages:(NSArray *)messages;


/**
 插入单条消息

 @param message 消息
 */
- (void)insertMessage:(NIMMessage *)message;


/**
 追加消息组

 @param messages 消息组
 @param autoBottom 自动到底部
 */
- (void)addMessages:(NSArray *)messages autoBottom:(BOOL)autoBottom;


/**
 更新消息

 @param message 消息
 */
- (void)updateMessage:(NIMMessage *)message;


/**
 查找消息

 @param message 消息
 @return 消息Model
 */
- (JTSessionMessageModel *)findMessage:(NIMMessage *)message;


/**
 删除消息

 @param message 消息
 @return 消息Model
 */
- (JTSessionMessageModel *)deleteMessage:(NIMMessage *)message;


/**
 滑动到底部

 @param animation 是否加载动画
 */
- (void)scrollTableViewBottom:(BOOL)animation;


/**
 开始编辑
 */
- (void)startEdit;


/**
 停止编辑
 */
- (void)stopEdit;

/**
 删除选择
 */
- (void)deleteChoose;
@end
