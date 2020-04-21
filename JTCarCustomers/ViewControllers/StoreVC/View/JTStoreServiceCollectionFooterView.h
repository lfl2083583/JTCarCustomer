//
//  JTStoreServiceCollectionFooterView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTBadgeView.h"
#import "ZTButtonExt.h"
#import "JTGradientButton.h"

@class JTStoreServiceCollectionFooterView;

@protocol JTStoreServiceCollectionFooterViewDelegate <NSObject>

- (void)shoppingCartInStoreServiceCollectionFooterView:(JTStoreServiceCollectionFooterView *)storeServiceCollectionFooterView;
- (void)makeAnAppointmentInStoreServiceCollectionFooterView:(JTStoreServiceCollectionFooterView *)storeServiceCollectionFooterView;
@end

@interface JTStoreServiceCollectionFooterView : UIView

@property (strong, nonatomic) UIButton *explainBT;
@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) JTBadgeView *badgeView;
@property (strong, nonatomic) UILabel *allPriceLB;
@property (strong, nonatomic) UILabel *workPriceLB;
@property (strong, nonatomic) ZTButtonExt *serviceBT;
@property (strong, nonatomic) JTGradientButton *confirmBT;

@property (assign, nonatomic) CGFloat allPrice;
@property (assign, nonatomic) CGFloat workPrice;
@property (assign, nonatomic) NSInteger bedge;
@property (weak, nonatomic) id<JTStoreServiceCollectionFooterViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTStoreServiceCollectionFooterViewDelegate>)delegate;

@end
