//
//  JTStoreServiceTableHeaderView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreServiceTableHeaderView.h"
#import "JTLivePlayViewController.h"
@implementation JTLiveItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.coverIV];
        [self addSubview:self.playIcon];
        [self addSubview:self.makeLB];
    }
    return self;
}

- (UIImageView *)coverIV
{
    if (!_coverIV) {
        _coverIV = [[UIImageView alloc] initWithFrame:self.bounds];
        _coverIV.layer.cornerRadius = 4.f;
        _coverIV.contentMode = UIViewContentModeScaleAspectFill;
        _coverIV.clipsToBounds = YES;
    }
    return _coverIV;
}

- (UIImageView *)playIcon
{
    if (!_playIcon) {
        _playIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.width-50)/2, (self.height-50)/2, 50, 50)];
        _playIcon.image = [UIImage imageNamed:@"bt_play"];
    }
    return _playIcon;
}

- (UILabel *)makeLB
{
    if (!_makeLB) {
        _makeLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width-20, 20)];
        _makeLB.textAlignment = NSTextAlignmentRight;
        _makeLB.font = Font(12);
        _makeLB.textColor = GreenColor;
        _makeLB.text = @"直播中";
    }
    return _makeLB;
}

- (void)setModel:(JTStoreServiceLiveModel *)model
{
    _model = model;
    [self.coverIV sd_setImageWithURL:[NSURL URLWithString:[model.coverUrlString avatarHandleWithSize:CGSizeMake(self.coverIV.width*2, self.coverIV.height*2)]]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[Utility currentViewController] presentViewController:[[JTLivePlayViewController alloc] initWithStoreServiceLiveModel:self.model] animated:YES completion:nil];
}

@end

@interface JTStoreServiceTableHeaderView ()

@property (assign, nonatomic) CGFloat maxWidth;

@property (strong, nonatomic) UILabel *promptLB;

@end

@implementation JTStoreServiceTableHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.promptLB];
        [self setBackgroundColor:WhiteColor];
    }
    return self;
}

- (void)setStoreServiceLiveModels:(NSMutableArray<JTStoreServiceLiveModel *> *)storeServiceLiveModels
{
    _storeServiceLiveModels = storeServiceLiveModels;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[JTLiveItem class]]) {
            [view setHidden:YES];
            [view removeFromSuperview];
        }
    }
    if (storeServiceLiveModels.count > 0) {
        self.promptLB.hidden = NO;
        CGFloat width, height, left = 10.0, top = self.promptLB.bottom + 10.0;
        width = height = (self.maxWidth - 30) / 2;
        for (NSInteger index = 0; index < storeServiceLiveModels.count ; index ++) {
            JTLiveItem *item = [[JTLiveItem alloc] initWithFrame:CGRectMake(left, top, width, height)];
            item.model = storeServiceLiveModels[index];
            if (left + width > self.maxWidth) {
                left = 10.0;
                top = CGRectGetMaxY(item.frame) + 10;
            }
            else
            {
                left = CGRectGetMaxX(item.frame) + 10;
            }
            if (index == storeServiceLiveModels.count - 1) {
                self.frame = CGRectMake(0, 0, self.maxWidth, CGRectGetMaxY(item.frame) + 10);
            }
            [self addSubview:item];
        }
    }
    else
    {
        self.promptLB.hidden = YES;
        self.frame = CGRectZero;
    }
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, self.maxWidth-20, 20)];
        _promptLB.font = Font(14);
        _promptLB.textColor = BlackLeverColor6;
        _promptLB.text = @"实时直播";
    }
    return _promptLB;
}

- (CGFloat)maxWidth
{
    if (_maxWidth == 0) {
        _maxWidth = App_Frame_Width-100;
    }
    return _maxWidth;
}
@end
