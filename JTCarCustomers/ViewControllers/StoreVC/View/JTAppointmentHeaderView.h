//
//  JTAppointmentHeaderView.h
//  JTCarCustomers
//
//  Created by jt on 2018/6/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTTimeItem : UIView;

@property (strong, nonatomic) UILabel *dateLB;
@property (strong, nonatomic) UILabel *weekLB;

@end;

@interface JTAppointmentHeaderView : UIView

@property (strong, nonatomic) UIScrollView *scrollview;

@end
