//
//  JTContactConfig.h
//  JTSocial
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JTContactSelectType) {
    JTContactSelectTypeCreateTeam,         // 创建群组
    JTContactSelectTypeAddTeamMember,      // 添加群组成员
    JTContactSelectTypeDeleteTeamMember,   // 删除群组成员
    JTContactSelectTypeMulti,              // 多选
    JTContactSelectTypeSingle,             // 单选
    JTContactSelectTypeThirdShare,         // 第三方分享
    JTContactSelectTypeCreateLabel,        // 创建标签
    JTContactSelectTypeShareActivity,      // 活动分享
    JTContactSelectTypeRepeatMessage,      // 转发消息
    JTContactSelectTypeRepeatCard,         // 发送名片
    JTContactSelectTypeShareInfomation,    // 分享资讯
    JTContactSelectTypeShareTeam,          // 分享群聊
    JTContactSelectTypeShareStore,         // 分享门店
};

@protocol JTContactConfig <NSObject>

@required

/**
 *  联系人选择器中的数据源类型
 *  当是群组时，需要设置群组id
 */
- (JTContactSelectType)selectType;

@optional

/**
 *  联系人选择器标题
 */
- (NSString *)title;

/**
 *  是否多选
 */
- (BOOL)needMutiSelected;

/**
 *  最多选择的人数
 */
- (NSInteger)maxSelectedNum;

/**
 *  超过最多选择人数时的提示
 */
- (NSString *)selectedOverFlowTip;

/**
 *  默认已经勾选的人或群组
 */
- (NSArray *)alreadySelectedMemberId;

/**
 *  显示数据的组合成员
 */
- (NSArray *)groupMember;

/**
 *  显示数据的组合标题
 */
- (NSArray *)groupTitle;

/**
 *  当数据源类型为群组时，需要设置的群id
 *
 *  @return 群id
 */
- (NSString *)teamId;

/**
 *   当需要转发消息时，需要传消息对象message / 当发送名片时传session
 *
 *  @return 消息对象message / 会话session
 */
- (id)source;


@end


/**
 *  内置配置-选择好友
 */
@interface JTContactFriendConfig : NSObject <JTContactConfig>

@property (nonatomic, assign) JTContactSelectType contactSelectType;

@property (nonatomic, assign) BOOL needMutiSelected;

@property (nonatomic, strong) NSArray *alreadySelectedMemberId;

@property (nonatomic, strong) NSMutableArray *groupMember;

@property (nonatomic, strong) NSArray *groupTitle;

@property (nonatomic, copy) NSString *teamId;

@property (nonatomic, strong) id source;

@end

/**
 *  内置配置-选择群成员
 */
@interface JTContactTeamMemberConfig : NSObject <JTContactConfig>

@property (nonatomic, assign) BOOL showAllMember;

@property (nonatomic, assign) JTContactSelectType contactSelectType;

@property (nonatomic, assign) BOOL needMutiSelected;

@property (nonatomic, strong) NSArray *members;

@property (nonatomic, strong) NSArray *alreadySelectedMemberId;

@property (nonatomic, strong) NSMutableArray *groupMember;

@property (nonatomic, strong) NSMutableArray *groupTitle;

@property (nonatomic, strong) id source;

@property (nonatomic, copy) NSString *teamId;



@end

