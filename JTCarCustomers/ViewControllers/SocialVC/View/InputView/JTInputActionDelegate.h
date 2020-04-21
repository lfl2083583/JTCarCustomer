//
//  JTInputActionDelegate.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JTMediaItem;
@class JTExpression;

@protocol JTInputActionDelegate <NSObject>

@optional

/**
 键盘状态

 @param isShow 是否弹起
 */
- (void)keyboardStatus:(BOOL)isShow;

/**
 高度发生改变

 @param height 高度
 */
- (void)callDidChangeHeight:(CGFloat)height;

/**
 发送文字

 @param text 文字
 @param users @用户信息
 */
- (void)onSendText:(NSString *)text atUsers:(NSArray *)users;

/**
 点击更多

 @param item 按钮信息
 */
- (void)onTapMediaItem:(JTMediaItem *)item;

/**
 表情添加收藏
 */
- (void)onTapExpressionAddCollection;

/**
 表情商店
 */
- (void)onTapExpressionStore;

/**
 表情管理
 */
- (void)onTapExpressionManage;

/**
 点击表情

 @param expression 表情
 */
- (void)onTapExpression:(JTExpression *)expression;

/**
 点击相机
 */
- (void)onTapBonus;

/**
 点击相机
 */
- (void)onTapCamera;

/**
 发送照片

 @param photos 照片数组
 */
- (void)onSendPhotos:(NSArray<UIImage *> *)photos;

/**
 发送视频

 @param path 视频地址
 */
- (void)onSendVideoPath:(NSString *)path;

/**
 发送音频

 @param path 音频地址
 */
- (void)onSendAudioPath:(NSString *)path;
@end
