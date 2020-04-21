//
//  JTSessionLocationTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"

static NSString *sessionLocationIdentifier = @"JTSessionLocationTableViewCell";

@interface JTSessionLocationTableViewCell : JTSessionTableViewCell

@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UILabel *titleLB;

@end
