//
//  JTBulletCenterTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/31.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

static NSString *bulletCenterCellIndentify = @"JTBulletCenterTableViewCell";

@interface JTBulletCenterItem : NSObject

@property (nonatomic, copy) NSString *itemID;
@property (nonatomic, copy) NSString *avatarUrl;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) BOOL isSeleted;


@end

@interface JTBulletCenterTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *checkBox;
@property (nonatomic, strong) ZTCirlceImageView *avatarView;
@property (nonatomic, strong) UILabel *rightLB;
@property (nonatomic, strong) UIView *bottomView;


@end
