//
//  JTCollectionInfomationTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCollectionTableViewCell.h"

static NSString *const collectionInfomationIdentifier = @"JTCollectionInfomationTableViewCell";

@interface JTCollectionInfomationTableViewCell : JTCollectionTableViewCell

@property (nonatomic, strong) UIImageView *contentImage;
@property (nonatomic, strong) UILabel *infomationTitle;
@property (nonatomic, strong) UILabel *infomationDetail;

@end
