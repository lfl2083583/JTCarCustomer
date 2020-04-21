//
//  JTStoreDetailHeaderView.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "STHeaderView.h"
#import "ZTButtonExt.h"
#import "JTStoreModel.h"

@class JTStoreDetailHeaderView;

typedef NS_ENUM(NSInteger, JTStoreDetailHeaderClickType) {
    JTStoreDetailHeaderClickTypeNavigation = 0,// 点击导航
    JTStoreDetailHeaderClickTypeCollection,    // 点击收藏
};

@protocol JTStoreDetailHeaderViewDelegate <NSObject>

- (void)storeDetailHeaderView:(JTStoreDetailHeaderView *)storeDetailHeaderView didSelectHeaderAtType:(JTStoreDetailHeaderClickType)storeDetailHeaderClickType;

@end

@interface JTStoreDetailHeaderView : STHeaderView

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *storeNameLB;
@property (strong, nonatomic) UILabel *makeLB;
@property (strong, nonatomic) UILabel *detailLB;
@property (strong, nonatomic) UILabel *addressLB;

@property (strong, nonatomic) ZTButtonExt *navigationBT;
@property (strong, nonatomic) ZTButtonExt *collectionBT;

@property (weak, nonatomic) id<JTStoreDetailHeaderViewDelegate> storeDetailHeaderViewDelegate;
@property (copy, nonatomic) JTStoreModel *model;

- (instancetype)initWithStoreDetailHeaderViewDelegate:(id<JTStoreDetailHeaderViewDelegate>)storeDetailHeaderViewDelegate;

@end
