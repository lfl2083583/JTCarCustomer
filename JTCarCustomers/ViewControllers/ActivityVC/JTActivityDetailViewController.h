//
//  JTActivityDetailViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef void(^ZT_ActivityDetailBlock)(void);

@interface JTActivityDetailViewController : BaseRefreshViewController

@property (nonatomic, copy) ZT_ActivityDetailBlock callBack;
@property (nonatomic, strong) id activityInfo;
@property (nonatomic, assign) BOOL showComment;

- (instancetype)initWithActivityID:(NSString *)activityID;

- (instancetype)initWithActivityID:(NSString *)activityID showComment:(BOOL)showComment;

@end
