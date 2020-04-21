//
//  JTStoreHeaderView.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "STHeaderView.h"
#import "ZTCirlceImageView.h"

@class JTStoreHeaderView;

typedef NS_ENUM(NSInteger, JTStoreHeaderClickType) {
    JTStoreHeaderClickTypeCar = 0,    // 点击车
    JTStoreHeaderClickTypeMaintain,   // 智能保养
    JTStoreHeaderClickTypeFault,      // 故障自查
    JTStoreHeaderClickTypeRescue,     // 道路救援
    JTStoreHeaderClickTypeParkingLot, // 预约车位
};

@protocol JTStoreHeaderViewDelegate <NSObject>

- (void)storeHeaderView:(JTStoreHeaderView *)storeHeaderView didSelectHeaderAtType:(JTStoreHeaderClickType)storeHeaderClickType;

@end

@interface JTStoreHeaderView : STHeaderView

@property (weak, nonatomic) id<JTStoreHeaderViewDelegate> storeHeaderViewDelegate;

- (instancetype)initWithStoreHeaderViewDelegate:(id<JTStoreHeaderViewDelegate>)storeHeaderViewDelegate;

- (void)reloadData;
@end
