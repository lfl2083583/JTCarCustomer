//
//  JTMaintenanceEditTableHeadView.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMaintenanceEditTableHeadView.h"

@implementation JTMaintenanceEditTableHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.mileageTF addTarget:self action:@selector(mileageTFEdite:) forControlEvents:UIControlEventAllEditingEvents];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)dateBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(maintenanceDateEdite:)]) {
        [_delegate maintenanceDateEdite:sender];
    }
}

- (void)mileageTFEdite:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(maintenanceMileageEdite:)]) {
        [_delegate maintenanceMileageEdite:sender];
    }
}

@end


