//
//  JTSessionTableViewCell.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "JTSessionMessageModel.h"
#import "JTSessionLayoutConfig.h"
#import "JTTeamPowerModel.h"

@class JTSessionTableViewCell;

typedef NS_ENUM(NSInteger, JTMenuType) {
    JTMenuTypeRemove,       // 删除用户
    JTMenuTypeBan,          // 禁言用户
    JTMenuTypeCancelBan,    // 取消禁言用户
    JTMenuTypeSelected,     // 选中用户
    
    JTMenuTypeCopy,         // 复制消息
    JTMenuTypeRepeat,       // 转发消息
    JTMenuTypeCollection,   // 收藏消息
    JTMenuTypeRevoke,       // 撤销消息
    JTMenuTypeDelete,       // 删除消息
    JTMenuTypeAdd,          // 添加到表情消息
    JTMenuTypeMultiselect,  // 多选消息
};

@protocol JTSessionTableViewCellDelegate <NSObject>

@optional

/**
 点击用户头像

 @param sessionTableViewCell sessionTableViewCell description
 @param yunxinID 用户云信ID
 */
- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell clickInAvatarAtYunxinID:(NSString *)yunxinID;

/**
 长按用户头像

 @param sessionTableViewCell sessionTableViewCell description
 @param yunxinID 用户云信ID
 */
- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell longInAvatarAtYunxinID:(NSString *)yunxinID;

/**
 点击消息

 @param sessionTableViewCell sessionTableViewCell description
 @param messageModel 消息MODEL
 */
- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell didSelectAtMessageModel:(JTSessionMessageModel *)messageModel;

/**
 点击MEUN

 @param sessionTableViewCell sessionTableViewCell description
 @param menuType menuType description
 */
- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell menuType:(JTMenuType)menuType;

/**
 选择消息
 
 @param sessionTableViewCell sessionTableViewCell description
 @param messageModel 消息MODEL
 */
- (void)sessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell didChoiceAtMessageModel:(JTSessionMessageModel *)messageModel;

@end

@protocol JTSessionTableViewCellDataSource <NSObject>

@optional

/**
 获取群权限

 @param sessionTableViewCell sessionTableViewCell description
 @return 群权限
 */
- (JTTeamPowerModel *)teamPowerModelInSessionTableViewCell:(JTSessionTableViewCell *)sessionTableViewCell;

@end

@interface JTSessionTableViewCell : UITableViewCell

@property (nonatomic, strong) ZTCirlceImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLB;
@property (nonatomic, strong) UIImageView *bubbleImageView;
@property (nonatomic, strong) UIActivityIndicatorView *traningActivityIndicator;  //发送loading
@property (nonatomic, strong) UIButton *retryButton;                              //重试
@property (nonatomic, strong) UIButton *choiceButton;                             //选择

@property (strong, nonatomic) JTSessionMessageModel *model;
@property (strong, nonatomic) NIMMessage *message;
@property (assign, nonatomic) BOOL isOutgoingMessage;
@property (assign, nonatomic) BOOL isEditMessage;
@property (weak, nonatomic) id<JTSessionTableViewCellDelegate> delegate;
@property (weak, nonatomic) id<JTSessionTableViewCellDataSource> dataSource;

- (void)initSubview;
- (void)onRetryMessage:(id)sender;
- (void)onTouchUpInside:(id)sender;
- (void)onValidTouchUpInside:(id)sender;
@end
