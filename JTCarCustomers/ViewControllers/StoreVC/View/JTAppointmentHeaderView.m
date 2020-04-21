//
//  JTAppointmentHeaderView.m
//  JTCarCustomers
//
//  Created by jt on 2018/6/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTAppointmentHeaderView.h"

@implementation JTTimeItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubview];
        [self.layer setBorderWidth:.5];
        [self.layer setCornerRadius:4.];
    }
    return self;
}

- (void)initSubview
{
    [self addSubview:self.dateLB];
    [self addSubview:self.weekLB];
}

- (UILabel *)dateLB
{
    if (!_dateLB) {
        _dateLB = [[UILabel alloc] init];
        _dateLB.font = Font(12);
        _dateLB.frame = CGRectMake(0, 5, self.width, (self.height-10)/2);
    }
    return _dateLB;
}

- (UILabel *)weekLB
{
    if (!_weekLB) {
        _weekLB = [[UILabel alloc] init];
        _weekLB.font = Font(12);
        _weekLB.frame = CGRectMake(0, self.dateLB.bottom, self.width, self.dateLB.height);
    }
    return _weekLB;
}

@end

@implementation JTAppointmentHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(0, 0, App_Frame_Width, 70)];
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    [self addSubview:self.scrollview];
    NSLog(@"%@", [self latelyAWeekTime]);
}

- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollview.contentSize = CGSizeMake(405, 0);
        _scrollview.showsVerticalScrollIndicator = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
    }
    return _scrollview;
}

// 未来一个星期
- (NSMutableArray *)latelyAWeekTime {
    NSMutableArray *weekArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i ++) {
        NSTimeInterval secondsPerDay = i * 24 * 60 * 60;
        NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        NSString *dateStr = [Utility exchageDate:currentDate format:@"MM-dd"];
        NSString *weekStr = [Utility exchageDate:currentDate format:@"EEEE"];
        //组合时间
        [weekArr addObject:@{@"dateStr": dateStr, @"weekStr": weekStr}];
    }
    return weekArr;
}
@end
