//
//  JTCollectionDetailViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import "JTCollectionModel.h"

@interface JTCollectionDetailViewController : BaseRefreshViewController

@property (nonatomic, strong) JTCollectionModel *model;

- (instancetype)initWithCollectionModel:(JTCollectionModel *)model;

@end
