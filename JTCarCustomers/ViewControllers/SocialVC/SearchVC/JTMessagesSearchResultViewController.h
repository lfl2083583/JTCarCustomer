//
//  JTMessagesSearchResultViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTMessagesSearchResultViewController : BaseRefreshViewController

@property (strong, nonatomic) NSArray *messages;
@property (strong, nonatomic) NSString *searchKeyword;

- (instancetype)initWithMessages:(NSArray *)messages searchKeyword:(NSString *)searchKeyword;


@end
