//
//  JTAliCertificationView.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import <UIKit/UIKit.h>

@interface JTAliCertificationAuditView : UIView

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *centerLB;
@property (nonatomic, strong) UIButton *bottomBtn;

@end

@interface JTAliCertificationView : UIView

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *topLB;
@property (nonatomic, strong) UILabel *centerLB;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) JTGradientButton *bottomBtn;
@property (nonatomic, strong) JTAliCertificationAuditView *auditView;

@end
