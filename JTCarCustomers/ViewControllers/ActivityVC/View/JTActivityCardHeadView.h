//
//  JTActivityCardHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, JTSlideLoction) {
    JTSlideLoctionLeft   = 0,
    JTSlideLoctionCenter = 1,
    JTSlideLoctionRight  = 2,
    JTSlideLoctionUnKnow = 3,
};

@interface JTActivityCardHeadView : UIView

@property (nonatomic, assign) JTSlideLoction slideLoction;

- (void)configActivityCardHeadViewWithInfo:(id)info;

@end
