//
//  JTCollectionVideoTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionTableViewCell.h"

static NSString *collectionVideoIdentifier = @"JTCollectionVideoTableViewCell";

@interface JTCollectionVideoTableViewCell : JTCollectionTableViewCell

@property (strong, nonatomic) UIImageView *contentImage;
@property (strong, nonatomic) UIImageView *playIcon;

@end
