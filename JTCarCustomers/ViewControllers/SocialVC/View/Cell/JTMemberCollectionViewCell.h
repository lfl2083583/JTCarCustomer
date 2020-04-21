//
//  JTMemberCollectionViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2017/6/21.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

static NSString *memberIdentifier = @"JTMemberCollectionViewCell";

@interface JTMemberCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) ZTCirlceImageView *avatar;
@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) UIImageView *makeIcon;

@end
