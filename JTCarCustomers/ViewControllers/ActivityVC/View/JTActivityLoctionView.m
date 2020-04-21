//
//  JTActivityLoctionView.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTActivityLoctionView.h"

@interface JTActivityLoctionView ()

@end

@implementation JTActivityLoctionView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.walkBtn.backgroundColor = WhiteColor;
    self.walkBtn.layer.borderColor = BlackLeverColor2.CGColor;
    self.walkBtn.layer.borderWidth = 1;
    [self.walkBtn setTitleColor:BlackLeverColor4 forState:UIControlStateNormal];
}

- (IBAction)routeTypeBtnClick:(UIButton *)sender {
    self.driveBtn.backgroundColor = WhiteColor;
    self.driveBtn.layer.borderColor = BlackLeverColor2.CGColor;
    self.driveBtn.layer.borderWidth = 1;
    [self.driveBtn setTitleColor:BlackLeverColor4 forState:UIControlStateNormal];
    self.walkBtn.backgroundColor = WhiteColor;
    self.walkBtn.layer.borderColor = BlackLeverColor2.CGColor;
    self.walkBtn.layer.borderWidth = 1;
    [self.walkBtn setTitleColor:BlackLeverColor4 forState:UIControlStateNormal];
    sender.backgroundColor = BlueLeverColor1;
    sender.layer.borderColor = BlueLeverColor1.CGColor;
    [sender setTitleColor:WhiteColor forState:UIControlStateNormal];
    if (_delegate && [_delegate respondsToSelector:@selector(transportationTypeChoosed:)]) {
        [_delegate transportationTypeChoosed:(sender == self.driveBtn )?MKDirectionsTransportTypeAutomobile:MKDirectionsTransportTypeWalking];
    }
    
}

- (IBAction)updateLoctionBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(updateLocationAgain)]) {
        [_delegate updateLocationAgain];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)comfirmBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(startNavDistionation)]) {
        [_delegate startNavDistionation];
    }
}

@end
