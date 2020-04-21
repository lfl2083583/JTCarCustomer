//
//  JTCarLifeDetailViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTCarLifeDetailViewController : BaseRefreshViewController

@property (nonatomic, copy) NSString *weburl;
@property (nonatomic, copy) NSString *navtitle;

- (instancetype)initWeburl:(NSString *)weburl navtitle:(NSString *)navtitle;

@end
