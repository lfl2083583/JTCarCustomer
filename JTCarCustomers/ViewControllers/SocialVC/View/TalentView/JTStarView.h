//
//  JTStarView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTPaddingButton : UIButton

@property (nonatomic, assign) CGFloat exWidth;

@end

@interface JTStarView : UIView

@property (nonatomic, assign) BOOL forSelect;

@property (nonatomic ,copy) void(^onStart)(NSInteger index);

- (void)markStar:(NSInteger)star;

@end
