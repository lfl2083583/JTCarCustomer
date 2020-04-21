//
//  JTCarCertificationStatusView.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTCarCertificationStatusView : UIView

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *subtitle;

- (instancetype)initWithFrame:(CGRect)frame carAuthStatus:(NSInteger)carAuthStatus;

@end
