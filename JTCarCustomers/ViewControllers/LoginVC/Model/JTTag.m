//
//  JTTag.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTTag.h"

static const CGFloat kDefaultFontSize = 13.0;

@implementation JTTag

- (instancetype)init {
    self = [super init];
    if (self) {
        _fontSize = kDefaultFontSize;
        _textColor = [UIColor blackColor];
        _bgColor = [UIColor whiteColor];
        _enable = YES;
    }
    return self;
}

- (instancetype)initWithText: (NSString *)text {
    self = [self init];
    if (self) {
        _text = text;
    }
    return self;
}

+ (instancetype)tagWithText: (NSString *)text {
    return [[self alloc] initWithText: text];
}

@end

