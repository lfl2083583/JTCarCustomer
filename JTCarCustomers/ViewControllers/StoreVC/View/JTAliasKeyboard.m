//
//  JTAliasKeyboard.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTAliasKeyboard.h"
#import "JTGradientButton.h"

#define kAlias @"粤,京,沪,浙,苏,鲁,晋,冀,豫,川,渝,辽,吉,黑,皖,鄂,湘,赣,闽,陕,甘,宁,蒙,津,贵,云,桂,琼,青,新,藏,使"

@implementation JTAliasKeyboard

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubview];
        [self addSubview:[Utility initLineRect:CGRectMake(0, 0, App_Frame_Width, 1) lineColor:BlackLeverColor2]];
        [self setBackgroundColor:BlackLeverColor1];
    }
    return self;
}

- (void)buttonClick:(UIButton *)sender
{
    if (self.choiceBlock) {
        self.choiceBlock(sender.titleLabel.text);
    }
    sender.backgroundColor = WhiteColor;
}

- (void)downClick:(UIButton *)sender
{
    sender.backgroundColor = UIColorFromRGB(0xb3b3b3);
}

- (void)upOutsideClick:(UIButton *)sender
{
    sender.backgroundColor = WhiteColor;
}

- (void)cancelClick:(id)sender
{
    [self hide];
}

- (void)initSubview
{
    NSArray *array = [kAlias componentsSeparatedByString:@","];
    CGFloat itemWidth = (App_Frame_Width - 50) / 9;
    CGFloat itemHeight = itemWidth * 42. / 32.;
    CGFloat itemLeft = 5, itemTop = 15;
    for (NSString *str in array) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [button setFrame:CGRectMake(itemLeft, itemTop, itemWidth, itemHeight)];
        [button setBackgroundColor:WhiteColor];
        [button.layer setCornerRadius:4.];
        [button.layer setBorderWidth:.5];
        [button.layer setBorderColor:BlackLeverColor2.CGColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(upOutsideClick:) forControlEvents:UIControlEventTouchUpOutside];
        itemLeft = CGRectGetMaxX(button.frame) + 5;
        if (itemWidth + itemLeft > App_Frame_Width) {
            itemLeft = 5;
            itemTop = CGRectGetMaxY(button.frame) + 15;
        }
        [self addSubview:button];
    }
    CGFloat height = itemTop + itemHeight + 15;
    self.frame = CGRectMake(0, APP_Frame_Height, App_Frame_Width, height);
    
    JTGradientButton *cancelBT = [JTGradientButton buttonWithType:UIButtonTypeCustom];
    [cancelBT setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBT setTitleColor:WhiteColor forState:UIControlStateNormal];
    CGFloat cancelWidth = itemHeight * 60 / 42;
    [cancelBT setFrame:CGRectMake(App_Frame_Width - cancelWidth - 5, itemTop, cancelWidth, itemHeight)];
    [cancelBT setCornerRadius:4.];
    [cancelBT addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBT];
}

- (void)showInView:(UIView *)view choiceBlock:(void (^)(NSString *))choiceBlock
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.15 animations:^{
        weakself.top = APP_Frame_Height - weakself.height;
    }];
    [view addSubview:self];
    [self setChoiceBlock:choiceBlock];
}

- (void)hide
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.15 animations:^{
        weakself.top = APP_Frame_Height;
    } completion:^(BOOL finished) {
        if (finished) {
            [weakself setHidden:YES];
            [weakself removeFromSuperview];
        }
        if (weakself.cancelBlock) {
            weakself.cancelBlock();
        }
    }];
}
@end
