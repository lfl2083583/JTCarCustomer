//
//  ZTTableView.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "ZTTableView.h"

@implementation ZTTableView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
