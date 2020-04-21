//
//  JTSessionInformationTableViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTSessionTableViewCell.h"

static NSString *sessionInformationIdentifier = @"JTSessionInformationTableViewCell";

@interface JTSessionInformationTableViewCell : JTSessionTableViewCell

@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *contentLB;

@end
