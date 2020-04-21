//
//  JTSessionViewController.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTAttentionTipTopView.h"
#import "JTInputView.h"
#import "JTBanCoverView.h"
#import "JTGradientButton.h"
#import "UIView+Spring.h"
#import "JTTeamAnnounceTipView.h"
#import "JTSessionConfigurator.h"
#import "JTSessionTool.h"
#import "JTSessionConfig.h"
#import "JTTeamPowerModel.h"
#import "JTSessionUtil.h"

@interface JTSessionViewController : UIViewController

@property (nonatomic, strong) UILabel *sessionTitleLB;                      // 标题
@property (nonatomic, strong) UIImageView *bottomImage;                     // 背景
@property (nonatomic, strong) JTAttentionTipTopView *attentionTipTopView;   // 关注
@property (nonatomic, strong) UITableView *tableView;                       // 表格
@property (nonatomic, strong) JTInputView *sessionInputView;                // 输入框
@property (nonatomic, strong) JTBanCoverView *inputCoverLB;                 // 输入框遮盖提示
@property (nonatomic, strong) JTGradientButton *deleteBT;                   // 全选删除按钮

@property (nonatomic, copy) NIMSession *session;                            // 会话
@property (nonatomic, copy) NIMMessage *locationMessage;                    // 定位消息
@property (nonatomic, strong) JTSessionConfigurator *sessionConfigurator;   // 辅助类
@property (nonatomic, strong) JTSessionTool *sessionTool;                   // 工具类
@property (nonatomic, strong) JTSessionConfig *sessionConfig;               // 配置类
@property (nonatomic, strong) JTTeamPowerModel *powerModel;                 // 群信息
@property (nonatomic, assign) BOOL isEditStatus;                            // 是否是编辑状态
@property (nonatomic, assign) BOOL isShowSessionInputView;                  // 是否是弹起输入框

/**
 初始化方法
 
 @param session 所属会话
 @return 会话页实例
 */
- (instancetype)initWithSession:(NIMSession *)session;

/**
 初始化方法
 
 @param session 所属对话
 @param locationMessage 消息体（定位的消息）
 @return 会话页实例
 */
- (instancetype)initWithSession:(NIMSession *)session locationMessage:(NIMMessage *)locationMessage;

/**
 发送消息
 
 @param message 消息体
 */
- (void)sendMessage:(NIMMessage *)message;

/**
 更新消息
 
 @param message message description
 @param completion completion description
 */
- (void)updateMessage:(NIMMessage *)message
           completion:(NIMUpdateMessageBlock)completion;
@end
