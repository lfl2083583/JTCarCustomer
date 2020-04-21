//
//  JTCollectionActivityTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCollectionTableViewCell.h"

static NSString *const collectionActivityIndentfier = @"JTCollectionActivityTableViewCell";

@interface JTCollectionActivityTableViewCell : JTCollectionTableViewCell

@property (nonatomic, strong) UIImageView *contentImage;
@property (nonatomic, strong) UILabel *themeLB;
@property (nonatomic, strong) UILabel *scheduleLB;
@property (nonatomic, strong) UILabel *siteLB;

@end
