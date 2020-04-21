//
//  JTSessionMessageModel.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIImage+Chat.h"
#import "NSMutableAttributedString+Emoticon.h"
#import "JTCustomAttachmentDefines.h"

#import "JTExpressionAttachment.h"
#import "JTCardAttachment.h"
#import "JTBonusAttachment.h"
#import "JTCallBonusAttachment.h"
#import "JTTeamOperationAttachment.h"
#import "JTTipAttachment.h"
#import "JTEvaluationAttachment.h"
#import "JTFunsAttachment.h"
#import "JTVideoAttachment.h"
#import "JTImageAttachment.h"
#import "JTGroupAttachment.h"
#import "JTInformationAttachment.h"
#import "JTActivityAttachment.h"
#import "JTShopAttachment.h"
#import "JTMoneyBonusReturnAttachment.h"
#import "JTActivityPromptAttachment.h"
#import "JTBusinessReplyAttachment.h"
#import "JTIdentityAuthAttachment.h"
#import "JTCarAuthAttachment.h"
#import "JTTeamOwnerTipAttachment.h"

@interface JTSessionMessageModel : NSObject

@property (strong, nonatomic) NIMMessage *message;
@property (assign, nonatomic) CGSize contentSize;
@property (strong, nonatomic) NSMutableAttributedString *string;  // 文本富文本消息
@property (strong, nonatomic) NSArray *links;
@property (strong, nonatomic) NSString *bubbleImage;

- (instancetype)initWithMessage:(NIMMessage *)message;

@end
