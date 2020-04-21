//
//  JTCollectionAudioTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTCollectionTableViewCell.h"

static NSString *collectionAudioIdentifier = @"JTCollectionAudioTableViewCell";

@interface JTCollectionAudioTableViewCell : JTCollectionTableViewCell

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UILabel *durationLB;

@end
