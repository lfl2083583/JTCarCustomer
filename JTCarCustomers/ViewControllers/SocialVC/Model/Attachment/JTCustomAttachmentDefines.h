//
//  JTCustomAttachmentDefines.h
//  NIM
//
//  Created by amao on 7/2/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#ifndef NIM_NTESCustomAttachmentTypes_h
#define NIM_NTESCustomAttachmentTypes_h

@class NIMKitBubbleStyleObject;

typedef NS_ENUM(NSInteger, CustomMessageType){
    CustomMessageTypeExpression        = 1001,   // GIF表情
    CustomMessageTypeCard              = 1002,   // 名片消息
    CustomMessageTypeBonus             = 1003,   // 红包消息
    CustomMessageTypeCallBonus         = 1004,   // 领取红包消息
    CustomMessageTypeTeamOperation     = 1005,   // 群操作消息
    CustomMessageTypeTip               = 1006,   // 普通提示消息
    CustomMessageTypeEvaluation        = 1007,   // 达人评价
    CustomMessageTypeVideo             = 1008,   // 自定义视频类型
    CustomMessageTypeImage             = 1009,   // 自定义图片类型
    CustomMessageTypeGroup             = 1010,   // 群名片
    CustomMessageTypeInformation       = 1011,   // 资讯名片
    CustomMessageTypeActivity          = 1012,   // 活动名片
    CustomMessageTypeShop              = 1013,   // 店铺名片
    
    CustomMessageTypeTeamInvite        = 3001,   // 群邀请加入
    CustomMessageTypeTeamInviteRefuse  = 3002,   // 群邀请拒绝
    CustomMessageTypeTeamApply         = 3003,   // 群申请加入
    CustomMessageTypeTeamApplyRefuse   = 3004,   // 群申请拒绝
    CustomMessageTypeTeamRemove        = 3005,   // 群移除
    CustomMessageTypeTeamDismiss       = 3006,   // 群解散
    
    CustomMessageFuns                  = 4001,   // 关注
    
    CustomMessageTypeMoneyBonusReturn  = 5001,   // 红包退还
    
    CustomMessageTypeActivityPrompt    = 6001,   // 活动消息提示
    CustomMessageTypeBusinessReply     = 6002,   // 商家回复
    CustomMessageTypeIdentityAuth      = 6003,   // 实名认证
    CustomMessageTypeCarAuth           = 6004,   // 车辆认证
    
    CustomMessageTypeCommentActivity   = 8001,   // 评论活动
    CustomMessageTypeCommentInformation= 8002,   // 评论资讯
    
    CustomMessageTypeTeamOwnerTip      = 10000   // 群主建群完提示
    
};

#define CMType          @"type"
#define CMData          @"data"

// 贴图消息
#define CMExpressionId         @"chartletId"     //表情ID
#define CMExpressionName       @"name"           //表情名称
#define CMExpressionUrl        @"url"            //表情gif地址
#define CMExpressionThumbnail  @"thumbnail"      //表情静态图片地址
#define CMExpressionWidht      @"width"          //表情宽度
#define CMExpressionHeight     @"height"         //表情高度

// 名片消息
#define CMCardUserId        @"userId"            //名片用户ID
#define CMCardUserName      @"name"              //名片用户昵称
#define CMCardUserNumber    @"username"          //名片用户娱人号
#define CMCardAvatar        @"avatar"            //名片用户头像

// 红包消息
#define CMBonusFromID        @"from_id"           //红包发送者ID
#define CMBonusFromYXAccID   @"from_accid"        //红包发送者云信ID
#define CMBonusID            @"packet_id"         //红包id
#define CMBonusContent       @"title"             //红包说明
#define CMBonusMoney         @"amount"            //红包金额
#define CMBonusCount         @"num"               //红包个数
#define CMBonusType          @"type"              //红包类型
#define CMBonusCreateDate    @"create_time"       //红包创建时间
// 红包拓展功能
#define CMBonusGrabbed       @"grabbed"            //红包抢过
#define CMBonusOverTime      @"overTime"           //红包超时
#define CMBonusOverGrab      @"overGrab"           //红包抢完
#define CMBonusClicking      @"clicking"           //红包点击

// 红包提示消息
#define CMCallBonusFromId          @"from_uid"      //发红包人ID
#define CMCallBonusFromName        @"from_nick"     //发红包的昵称
#define CMCallBonusId              @"packet_id"     //红包ID
#define CMCallBonusToId            @"rob_uid"       //抢红包人ID
#define CMCallBonusToName          @"rob_nick"      //抢红包人昵称
#define CMCallBonusSessionID       @"toid"          //会话ID
#define CMCallBonusType            @"type"          //红包类型
#define CMCallBonusLastFlag        @"is_last"       //是否是最后一个

// 群操作消息
#define CMTeamOperationActionType   @"action_type"  //操作类型
#define CMTeamOperationSessionId    @"group_id"     //会话ID
#define CMTeamOperationUserInfo     @"user_info"    //操作人用户信息
#define CMTeamOperationUserList     @"user_list"    //被操作人用户信息
#define CMTeamOperationMessage      @"msg"          //内容

// 普通提示消息
#define CMTipText            @"text"  //提示文字

// 达人评价
#define CMEvaluationText     @"text"  //提示文字

// 自定义视频消息
#define CMCustomVideoUrl                  @"videoUrl"    // 视频网络地址
#define CMCustomVideoCoverUrl             @"coverUrl"    // 视频封面
#define CMCustomVideoWidth                @"width"       // 视频宽度（可根据封面图算出）
#define CMCustomVideoHeight               @"height"      // 视频高度（可根据封面图算出）

// 自定义图片消息
#define CMCustomImageUrl                  @"picUrl"      // 图片网络地址
#define CMCustomImageThumbnail            @"thumbnail"   // 图片缩图
#define CMCustomImageWidth                @"width"       // 图片宽度
#define CMCustomImageHeight               @"height"      // 图片高度

// 群名片消息
#define CMCustomGroupID           @"id"                // 群ID
#define CMCustomGroupName         @"name"              // 群名称
#define CMCustomGroupIcon         @"icon"              // 群logo

// 资讯名片
#define CMCustomInformationID             @"id"          // 资讯ID
#define CMCustomInformationH5Url          @"h5_url"      // 资讯H5
#define CMCustomInformationCoverUrl       @"picUrl"      // 资讯封面图片
#define CMCustomInformationTitle          @"title"       // 资讯标题
#define CMCustomInformationContent        @"content"     // 资讯内容

// 活动名片
#define CMCustomActivityID                  @"id"         // 活动ID
#define CMCustomActivityCoverUrl            @"image"      // 活动封面图片
#define CMCustomActivityTheme               @"theme"      // 活动主题
#define CMCustomActivityTime                @"time"       // 活动时间
#define CMCustomActivityAddress             @"address"    // 活动地点

// 店铺名片
#define CMCustomShopID                 @"id"          // 店铺ID
#define CMCustomShopCoverUrl           @"picUrl"      // 店铺封面图片
#define CMCustomShopName               @"name"        // 店铺名称
#define CMCustomShopScore              @"score"       // 店铺评分
#define CMCustomShopTime               @"time"        // 店铺营业时间
#define CMCustomShopAddress            @"address"     // 店铺地址




// 群邀请加入
#define CMTeamInviteId                @"invite"      //邀请ID
#define CMTeamInviteUserId            @"uid"         //用户ID
#define CMTeamInviteYunXinId          @"accid"       //用户云信ID
#define CMTeamInviteUserName          @"nick_name"   //用户昵称
#define CMTeamInviteUserAvatar        @"avatar"      //用户头像
#define CMTeamInviteTeamId            @"group_id"    //群ID
#define CMTeamInviteTeamName          @"group_name"  //群名称
#define CMTeamInviteJoinType          @"join_type"   //加入方式
#define CMTeamInviteTime              @"time"        //邀请时间
#define CMTeamInviteOperationType     @"type"        //操作类型

// 群邀请拒绝
#define CMTeamInviteRefuseInviteId          @"invite"      //邀请ID
#define CMTeamInviteRefuseUserId            @"uid"         //用户ID
#define CMTeamInviteRefuseYunXinId          @"accid"       //用户云信ID
#define CMTeamInviteRefuseUserName          @"nick_name"   //用户昵称
#define CMTeamInviteRefuseUserAvatar        @"avatar"      //用户头像
#define CMTeamInviteRefuseTeamId            @"group_id"    //群ID
#define CMTeamInviteRefuseTeamName          @"group_name"  //群名称
#define CMTeamInviteRefuseTime              @"time"        //邀请拒绝时间
#define CMTeamInviteRefuseOperationType     @"type"        //操作类型

// 群申请加入
#define CMTeamApplyInviteId          @"invite"     //邀请ID
#define CMTeamApplyUserId            @"uid"        //用户ID
#define CMTeamApplyYunXinId          @"accid"      //用户云信ID
#define CMTeamApplyUserName          @"nick_name"  //用户昵称
#define CMTeamApplyUserAvatar        @"avatar"     //用户头像
#define CMTeamApplyTeamId            @"group_id"   //群ID
#define CMTeamApplyTeamName          @"group_name" //群名称
#define CMTeamApplyRemarks           @"remarks"    //备注
#define CMTeamApplyJoinType          @"join_type"  //加入方式
#define CMTeamApplyTime              @"time"       //邀请时间
#define CMTeamApplyOperationType     @"type"       //操作类型

// 群申请拒绝
#define CMTeamApplyRefuseTeamId        @"group_id"    //群ID
#define CMTeamApplyRefuseTeamName      @"group_name"  //群名称
#define CMTeamApplyRefuseTeamAvatar    @"avatar"      //群头像
#define CMTeamApplyRefuseUserId        @"uid"         //处理人ID
#define CMTeamApplyRefuseYunXinId      @"accid"       //处理人云信ID
#define CMTeamApplyRefuseUserName      @"nick_name"   //处理人昵称
#define CMTeamApplyRefuseTime          @"time"        //申请拒绝时间
#define CMTeamApplyRefuseInviteId      @"invite"      //邀请ID
#define CMTeamApplyRefuseJoinType      @"join_type"   //加入方式
#define CMTeamApplyRefuseOperationType @"type"        //操作类型

// 群移除
#define CMTeamRemoveTeamId             @"group_id"    //群ID
#define CMTeamRemoveTeamName           @"group_name"  //群名称
#define CMTeamRemoveTeamAvatar         @"avatar"      //群头像
#define CMTeamRemoveUserId             @"uid"         //处理人ID
#define CMTeamRemoveYunXinId           @"accid"       //处理人云信ID
#define CMTeamRemoveUserName           @"nick_name"   //处理人昵称
#define CMTeamRemoveTime               @"time"        //移除时间
#define CMTeamRemoveOperationType      @"type"        //操作类型

// 群解散
#define CMTeamDismissTeamId            @"group_id"    //群ID
#define CMTeamDismissTeamName          @"group_name"  //群名称
#define CMTeamDismissTeamAvatar        @"avatar"      //群头像
#define CMTeamDismissUserId            @"uid"         //处理人ID
#define CMTeamDismissYunXinId          @"accid"       //处理人云信ID
#define CMTeamDismissUserName          @"nick_name"   //处理人昵称
#define CMTeamDismissTime              @"time"        //解散时间




// 关注
#define CMFunsUserId          @"uid"      //用户id
#define CMFunsYunXinId        @"accid"    //云信id
#define CMFunsType            @"type"     //类型（1关注者消息通知，0被关注者消息通知）
#define CMFunsTime            @"time"     //时间




// 红包退还
#define CMMoneyBonusReturnBonusId     @"packet_id"    //红包ID
#define CMMoneyBonusReturnTitle       @"title"        //退还标题
#define CMMoneyBonusReturnMoney       @"account"      //退还金额
#define CMMoneyBonusReturnReason      @"reason"       //退还原因
#define CMMoneyBonusReturnTime        @"rest_time"    //退还时间
#define CMMoneyBonusReturnRemarks     @"remarks"      //退还备注




// 活动消息提示
#define CMActivityID                  @"activity_id"   //活动ID
#define CMActivityContent             @"text"          //活动内容

// 商家回复
#define CMBusinessReplyContent        @"content"   //回复内容

// 实名认证
#define CMIdentityAuthStatus          @"status"    //认证状态1.成功，0.失败
#define CMIdentityAuthContent         @"content"   //认证成功或失败的内容

// 车辆认证
#define CMCarAuthStatus          @"status"    //认证状态1.成功，0.失败
#define CMCarAuthContent         @"content"   //认证成功或失败的内容
#define CMCarAuthID              @"car_id"    //车辆ID




// 评论活动
#define CMCommentActivityAvatarUrl       @"avatar"     //活动回复人头像
#define CMCommentActivityName            @"nick_name"  //活动回复人昵称
#define CMCommentActivityUserID          @"uid"        //活动回复人ID
#define CMCommentActivityContent         @"content"    //活动回复内容
#define CMCommentActivityTime            @"create_time"//活动回复时间
#define CMCommentActivityCoverUrl        @"detail_pic" //活动封面图
#define CMCommentActivityUrl             @"h5_url"     //活动详情地址
#define CMCommentActivityID              @"obj_id"     //活动ID

// 评论资讯
#define CMCommentInformationAvatarUrl       @"avatar"     //活动回复人头像
#define CMCommentInformationName            @"nick_name"  //活动回复人昵称
#define CMCommentInformationUserID          @"uid"        //活动回复人ID
#define CMCommentInformationContent         @"content"    //活动回复内容
#define CMCommentInformationTime            @"create_time"//活动回复时间
#define CMCommentInformationCoverUrl        @"detail_pic" //活动封面图
#define CMCommentInformationUrl             @"h5_url"     //活动详情地址
#define CMCommentInformationID              @"obj_id"     //活动ID



// 群主建群完提示
#define CMTeamOwnerTipText     @"text"  //提示文字

#endif

@protocol JTSessionContentConfig <NSObject>
@optional

- (CGSize)contentSize:(NIMMessage *)message;

- (NSMutableAttributedString *)contenText:(NIMMessage *)message;

- (NSArray *)contentLinks:(NIMMessage *)message;

- (NSString *)contentBubbleImage:(NIMMessage *)message;

@end

#import "UIImage+Chat.h"
#import "NSMutableAttributedString+Emoticon.h"

#define JTMessageTextFont 16
#define JTTipTextFont 12
#define JTBubbleMaxWidth  App_Frame_Width-130

