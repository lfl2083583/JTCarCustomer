//
//  JTTeamManageOperationViewController.h
//  JTSocial
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef enum : NSUInteger {
    TeamManageOperationTypePower,  // 权限管理
    TeamManageOperationTypeBan     // 禁言
    
} TeamManageOperationType;

@interface JTTeamManageOperationViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, assign) TeamManageOperationType teamManageOperationType;

- (instancetype)initWithSession:(NIMSession *)session teamManageOperationType:(TeamManageOperationType)teamManageOperationType;
@end
