//
//  JTStoreServiceCollectionHeaderView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"

@interface JTStoreServiceCollectionHeaderView : UIView

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) ZTCirlceImageView *carIcon;
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *subTitleLB;
@property (strong, nonatomic) UIButton *manageBT;

@property (copy, nonatomic) JTCarModel *model;

@end
