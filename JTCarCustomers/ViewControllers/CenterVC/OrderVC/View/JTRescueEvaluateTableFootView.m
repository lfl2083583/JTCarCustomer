//
//  JTRescueEvaluateTableFootView.m
//  JTCarCustomers
//
//  Created by lious on 2018/6/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTRescueEvaluateTableFootView.h"

@interface JTRescueEvaluateTableFootView ()

@property (nonatomic, strong) UIButton *checkBox;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *detailLB;

@end

@implementation JTRescueEvaluateTableFootView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.checkBox = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
        [self.checkBox setImage:[UIImage imageNamed:@"icon_accessory_pressed"] forState:UIControlStateNormal];
        [self.checkBox setImage:[UIImage imageNamed:@"icon_accessory_selected"] forState:UIControlStateSelected];
        [self.checkBox addTarget:self action:@selector(checkBoxClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.checkBox];
        
        self.titleLB = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.checkBox.frame)+2, 10, 120, 30)];
        [self.titleLB setFont:Font(14)];
        [self.titleLB setTextColor:BlackLeverColor5];
        [self.titleLB setText:@"匿名评价"];
        [self addSubview:self.titleLB];
        
        self.detailLB = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.checkBox.frame), self.width-40, 40)];
        [self.detailLB setFont:Font(14)];
        [self.detailLB setNumberOfLines:0];
        [self.detailLB setTextColor:BlackLeverColor3];
        [self.detailLB setText:@"若勾选【匿名评价】，将不会对外公开您的头像，昵称给其他用户和商家"];
        [self addSubview:self.detailLB];
    }
    
    return self;
}

- (void)checkBoxClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(evaluateTableFootViewCheckBoxIsSeleted:)]) {
        [_delegate evaluateTableFootViewCheckBoxIsSeleted:sender.selected];
    }
}

@end
