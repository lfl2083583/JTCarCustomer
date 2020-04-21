//
//  JTForwardPopupView.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, JTSelectType) {
    JTSelectTypeRepeatMessage,   //转发消息
    JTSelectTypeSendCard,        //发送名片
    JTSelectTypeShareActivity,   //分享活动
    JTSelectTypeShareStore,      //分享门店
    JTSelectTypeShareInfomation, //分享资讯
    JTSelectTypeShareTeam,       //分享群聊
};

typedef NS_ENUM(NSUInteger, JTPopupActionType) {
    JTPopupActionTypeCancel,  //取消
    JTPopupActionTypeDefault, //确定
};


typedef void(^ZT_ForwardPopupBlock)(NSString *content, JTPopupActionType actionType);

@interface JTForwardPopupView : UIView

@property (nonatomic, assign) NIMSessionType sessionType;
@property (nonatomic, assign) JTSelectType selectType;
@property (nonatomic, copy) ZT_ForwardPopupBlock callBack;

- (instancetype)initWithSource:(id)source selectType:(JTSelectType)selectType sessionType:(NIMSessionType )sessionType;

@end
