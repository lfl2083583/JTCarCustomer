//
//  JTCollectionImageTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionTableViewCell.h"

static NSString *collectionImageIdentifier = @"JTCollectionImageTableViewCell";

@interface JTCollectionImageTableViewCell : JTCollectionTableViewCell

@property (strong, nonatomic) UIImageView *contentImage;

@end
