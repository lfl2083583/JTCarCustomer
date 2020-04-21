//
//  JTCollectionDetailExpressionTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCollectionTableViewCell.h"
#import <FLAnimatedImage/FLAnimatedImageView.h>

static NSString *const collectionDetailExpressionIdentifier = @"JTCollectionDetailExpressionTableViewCell";

@interface JTCollectionDetailExpressionTableViewCell : JTCollectionTableViewCell

@property (nonatomic, strong) FLAnimatedImageView *contentImage;

@end
