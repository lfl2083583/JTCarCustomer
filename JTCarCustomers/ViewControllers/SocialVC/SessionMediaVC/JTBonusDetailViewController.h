//
//  JTBonusDetailViewController.h
//  JTSocial
//
//  Created by apple on 2017/8/29.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"


@interface JTBonusDetailModel : NSObject

@property (nonatomic, copy) NSString *sendUserAvatar;      // 红包发送人头像
@property (nonatomic, copy) NSString *sendUserName;        // 红包发送人昵称
@property (nonatomic, copy) NSString *sendUserID;          // 红包发送人ID

@property (nonatomic, copy) NSString *bonusID;         // 红包ID
@property (nonatomic, copy) NSString *bonusTitle;      // 红包标题
@property (nonatomic, assign) NSInteger bonusType;     // 红包类型
@property (nonatomic, assign) NSInteger bonusCount;    // 红包个数
@property (nonatomic, assign) CGFloat bonusMoney;      // 红包金额

@property (nonatomic, assign) NSInteger bonusRobCount;     // 红包已抢个数
@property (nonatomic, assign) CGFloat bonusRobMoney;       // 抢到的金额
@property (nonatomic, assign) NSInteger bonusRobTime;      // 红包抢的时间
@property (nonatomic, assign) CGFloat robMoney;            // 自己抢到的金额
@property (nonatomic, assign) BOOL isGrabbed;              // 是否自己已抢
@property (nonatomic, assign) BOOL isSender;               // 是否是自己发
@property (nonatomic, assign) BOOL isOverTime;             // 是否超时

@property (nonatomic, strong) NSString *timeTitle;

@end

@interface JTBonusListModel : NSObject

@property (nonatomic, copy) NSString *receiveTime;
@property (nonatomic, assign) BOOL isMax;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *money;
@property (nonatomic, copy) NSString *senderID;

@end


@interface JTBonusDetailViewController : BaseRefreshViewController

@property (strong, nonatomic) JTBonusDetailModel *bonusDetailModel;

- (instancetype)initWithBonusDetailModel:(JTBonusDetailModel *)bonusDetailModel bonusList:(NSArray *)bonusList;

@end
