//
//  JTSessionCardTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/7/19.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"
#import "ZTCirlceImageView.h"

static NSString *sessionCardIdentifier = @"JTSessionCardTableViewCell";

@interface JTSessionCardTableViewCell : JTSessionTableViewCell

@property (nonatomic, strong) ZTCirlceImageView *avatar;
@property (nonatomic, strong) UILabel *callLB;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *noteLB;

@end
