//
//  JTCollectionAddressTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionTableViewCell.h"

static NSString *collectionAddressIdentifier = @"JTCollectionAddressTableViewCell";

@interface JTCollectionAddressTableViewCell : JTCollectionTableViewCell

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *detailLB;

@end
