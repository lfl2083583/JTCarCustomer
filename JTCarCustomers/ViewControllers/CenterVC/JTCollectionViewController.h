//
//  JTCollectionViewController.h
//  JTSocial
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTCollectionViewController : BaseRefreshViewController

@property (copy, nonatomic) void(^doneBlock)(NIMMessage *message);

- (instancetype)initWithDoneBlock:(void (^)(NIMMessage *message))doneBlock;
@end
