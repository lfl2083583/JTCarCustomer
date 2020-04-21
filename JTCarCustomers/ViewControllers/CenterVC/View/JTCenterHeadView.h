//
//  JTCenterHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTCenterHeadViewDelegate <NSObject>

- (void)headViewAvatarClick;
- (void)headViewQRClick;

@end

@interface JTCenterHeadView : UIView

@property (nonatomic, weak) id<JTCenterHeadViewDelegate>delegate;

- (void)refreshHeadViewData;

@end


@interface JTCenterFootView : UIView

@property (nonatomic, strong) UILabel *leftLabel;

@end
