//
//  JTActivityCommentViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef void(^ZT_ActivityCommentBlock)(NSInteger totalCount);


@interface JTActivityCommentViewController : BaseRefreshViewController

@property (nonatomic, copy) NSString *activityID;
@property (nonatomic, copy) ZT_ActivityCommentBlock callBack;

- (instancetype)initWithActivityID:(NSString *)activityID;

@end
