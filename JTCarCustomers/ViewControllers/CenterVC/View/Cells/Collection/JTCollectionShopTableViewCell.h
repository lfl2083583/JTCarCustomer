//
//  JTcollectionShopTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/10.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "ZTStarView.h"
#import "JTCollectionTableViewCell.h"

static NSString *collectionShopIdentifier = @"JTCollectionShopTableViewCell";

@interface JTCollectionShopTableViewCell : JTCollectionTableViewCell

@property (nonatomic, strong) UILabel *shopNameLB;
@property (nonatomic, strong) UIImageView *contentImage;
@property (nonatomic, strong) ZTStarView *starView;
@property (nonatomic, strong) UILabel *businessHoursLB;
@property (nonatomic, strong) UILabel *siteLB;

@end
