//
//  JTStoreServiceTableHeaderView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTStoreServiceLiveModel.h"

@interface JTLiveItem: UIView

@property (strong, nonatomic) UIImageView *coverIV;
@property (strong, nonatomic) UIImageView *playIcon;
@property (strong, nonatomic) UILabel *makeLB;

@property (copy, nonatomic) JTStoreServiceLiveModel *model;

@end

@interface JTStoreServiceTableHeaderView : UIView

@property (copy, nonatomic) NSMutableArray<JTStoreServiceLiveModel *> *storeServiceLiveModels;

@end
