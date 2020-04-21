//
//  ZTTextField.m
//  QTNewIMApp
//
//  Created by apple on 2017/6/30.
//  Copyright © 2017年 z. All rights reserved.
//

#import "ZTTextField.h"

@implementation ZTTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    int margin = 15;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - 2*margin, bounds.size.height);
    return inset;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    int margin = 15;
    CGRect inset = CGRectMake(bounds.origin.x + margin, bounds.origin.y, bounds.size.width - 2*margin, bounds.size.height);
    return inset;
}

@end
