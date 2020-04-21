//
//  JTBanCoverView.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTBanCoverView.h"

@implementation JTBanCoverView

- (void)setTimeInterval:(double)timeInterval
{
    _timeInterval = timeInterval;
    if (timeInterval <= 0) {
        if (timer) {
            dispatch_cancel(timer);
        }
        self.hidden = YES;
    }
    else
    {
        self.hidden = NO;
        __block NSInteger second = timeInterval;
        __weak typeof(self) weakself = self;
        dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 60 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (second <= 0) {
                    weakself.hidden = YES;
                    dispatch_cancel(timer);
                    if (weakself.delegate && [weakself.delegate respondsToSelector:@selector(banCoverViewToCancel:)]) {
                        [weakself.delegate banCoverViewToCancel:weakself];
                    }
                } else {
                    NSInteger hour = second / 3600;
                    NSInteger minute = ceilf(second % 3600 / 60.0);
                    if (hour > 0) {
                        weakself.text = [NSString stringWithFormat:@"禁言中，约%d小时%d分钟后解除", (int)hour, (int)minute];
                    } else {
                        weakself.text = [NSString stringWithFormat:@"禁言中，约%d分钟后解除", (int)minute];
                    }
                    second-=60;
                }
            });
        });
        dispatch_resume(timer);
    }
}

@end
