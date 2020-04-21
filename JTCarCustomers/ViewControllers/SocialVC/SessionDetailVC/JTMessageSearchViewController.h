//
//  JTMessageSearchViewController.h
//  JTSocial
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"


@interface JTMessageSearchViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMSession *session;

- (instancetype)initWithSession:(NIMSession *)session;

@end
