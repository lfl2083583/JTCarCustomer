//
//  JTSessionVideoTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"

static NSString *sessionVideoIdentifier = @"JTSessionVideoTableViewCell";

@interface JTSessionVideoTableViewCell : JTSessionTableViewCell

@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UIImageView *playIcon;

@end
