//
//  JTActivityDetailBottomView.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTActivityDetailBottomView.h"

@interface JTActivityDetailBottomView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end


@implementation JTActivityDetailBottomView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self setWidth:App_Frame_Width];
    if (App_Frame_Width == 320) {
        self.widthConstraint.constant = 95;
    }
}

- (IBAction)joinBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(joinActivityTeam)]) {
        [_delegate joinActivityTeam];
    }
}

- (IBAction)commentBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(commentActivity)]) {
        [_delegate commentActivity];
    }
}

- (IBAction)collectBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(collectActivity)]) {
        [_delegate collectActivity];
    }
}

- (IBAction)forwardBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(forwardActivity)]) {
        [_delegate forwardActivity];
    }
}

@end
