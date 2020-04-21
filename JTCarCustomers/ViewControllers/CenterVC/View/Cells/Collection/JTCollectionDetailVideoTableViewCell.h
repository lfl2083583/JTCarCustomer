//
//  JTCollectionDetailVideoTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCollectionTableViewCell.h"

static NSString *const collectionDetailVideoIdentifier = @"JTCollectionDetailVideoTableViewCell";

@interface JTCollectionDetailVideoTableViewCell : JTCollectionTableViewCell

@property (strong, nonatomic) UIImageView *contentImage;
@property (strong, nonatomic) UIImageView *playIcon;

@end
