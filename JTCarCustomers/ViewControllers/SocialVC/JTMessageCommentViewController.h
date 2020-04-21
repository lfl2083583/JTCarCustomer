//
//  JTMessageCommentViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTMessageCommentViewController : BaseRefreshViewController

@property (nonatomic, copy) NIMSession *session;

/**
 初始化方法
 
 @param session 所属会话
 @return 会话页实例
 */
- (instancetype)initWithSession:(NIMSession *)session;

@end
