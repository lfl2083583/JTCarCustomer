//
//  JTSessionExpressionTableViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>

static NSString *sessionExpressionIdentifier = @"JTSessionExpressionTableViewCell";

@interface JTSessionExpressionTableViewCell : JTSessionTableViewCell

@property (strong, nonatomic) FLAnimatedImageView *photo;

@end
