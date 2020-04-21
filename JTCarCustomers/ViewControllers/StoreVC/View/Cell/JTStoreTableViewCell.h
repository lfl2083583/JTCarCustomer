//
//  JTStoreTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTStarView.h"
#import "JTStoreModel.h"

static NSString *storeIndentifier = @"JTStoreTableViewCell";

@interface JTStoreTableViewCell : UITableViewCell

@property (strong, nonatomic) UIImageView *coverImage;
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *makeLB;
@property (strong, nonatomic) ZTStarView *starView;
@property (strong, nonatomic) UILabel *scoreLB;
@property (strong, nonatomic) UILabel *distanceLB;
@property (strong, nonatomic) UILabel *addressLB;

@property (copy, nonatomic) JTStoreModel *model;
@end
