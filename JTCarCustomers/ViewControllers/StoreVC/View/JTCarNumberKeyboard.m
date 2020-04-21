//
//  JTCarNumberKeyboard.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarNumberKeyboard.h"
#import "JTGradientButton.h"

#define kCarNumber @"港,澳,学,警,领,1,2,3,4,5,6,7,8,9,0,Q,W,E,R,T,Y,U,I,O,A,S,D,F,G,H,J,K,P,Z,X,C,V,B,N,M,L"

@implementation JTCarNumberKeyboard

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initSubview];
        [self setBackgroundColor:BlackLeverColor1];
    }
    return self;
}

- (NSMutableString *)text
{
    if (!_text) {
        _text = [[NSMutableString alloc] init];
    }
    return _text;
}

- (void)closeClick:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(cancelInCarNumberKeyboard:)]) {
        [_delegate cancelInCarNumberKeyboard:self];
    }
}

- (void)buttonClick:(UIButton *)sender
{
    [self.text appendString:sender.titleLabel.text];
    if (_delegate && [_delegate respondsToSelector:@selector(carNumberKeyboard:didChangeText:)]) {
        [_delegate carNumberKeyboard:self didChangeText:self.text];
    }
    sender.backgroundColor = ([sender.backgroundColor isEqual:WhiteColor]) ? UIColorFromRGB(0xb3b3b3) : WhiteColor;
}

- (void)downClick:(UIButton *)sender
{
    sender.backgroundColor = ([sender.backgroundColor isEqual:WhiteColor]) ? UIColorFromRGB(0xb3b3b3) : WhiteColor;
}

- (void)upOutsideClick:(UIButton *)sender
{
    sender.backgroundColor = ([sender.backgroundColor isEqual:WhiteColor]) ? UIColorFromRGB(0xb3b3b3) : WhiteColor;
}

- (void)completeClick:(UIButton *)sender
{
    sender.backgroundColor = ([sender.backgroundColor isEqual:WhiteColor]) ? UIColorFromRGB(0xb3b3b3) : WhiteColor;
    if (_delegate && [_delegate respondsToSelector:@selector(cancelInCarNumberKeyboard:)]) {
        [_delegate cancelInCarNumberKeyboard:self];
    }
}

- (void)deleteClick:(UIButton *)sender
{
    sender.backgroundColor = ([sender.backgroundColor isEqual:WhiteColor]) ? UIColorFromRGB(0xb3b3b3) : WhiteColor;
    if (self.text.length > 0) {
        [self.text deleteCharactersInRange:NSMakeRange(self.text.length-1, 1)];
        if (_delegate && [_delegate respondsToSelector:@selector(carNumberKeyboard:didChangeText:)]) {
            [_delegate carNumberKeyboard:self didChangeText:self.text];
        }
    }
}

- (void)initSubview
{
    UIButton *closeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBT setImage:[UIImage imageNamed:@"icon_down_keyboard"] forState:UIControlStateNormal];
    [closeBT setFrame:CGRectMake(App_Frame_Width-64, 0, 64, 42)];
    [closeBT addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBT];
    
    [self addSubview:[Utility initLineRect:CGRectMake(0, closeBT.bottom, App_Frame_Width, 1) lineColor:BlackLeverColor2]];
    
    NSArray *array = [kCarNumber componentsSeparatedByString:@","];
    CGFloat firstLineWidth = (App_Frame_Width - 30) / 5;
    CGFloat secondLineWidth = (App_Frame_Width - 55) / 10;
    CGFloat thirdLineWidth = (App_Frame_Width - 50) / 9;
    CGFloat itemWidth = firstLineWidth;

    CGFloat itemHeight = thirdLineWidth * 42. / 32.;
    CGFloat itemLeft = 5, itemTop = 10 + closeBT.bottom;
    CGFloat row = 0, index = 0;
    for (NSString *str in array) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
        [button.layer setCornerRadius:4.];
        [button.layer setBorderWidth:.5];
        [button.layer setBorderColor:BlackLeverColor2.CGColor];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(upOutsideClick:) forControlEvents:UIControlEventTouchUpOutside];

        if (row == 0) {
            itemWidth = firstLineWidth;
            [button setBackgroundColor:UIColorFromRGB(0xb3b3b3)];
        }
        else if (row == 1) {
            itemWidth = secondLineWidth;
            [button setBackgroundColor:UIColorFromRGB(0xb3b3b3)];
        }
        else
        {
            itemWidth = thirdLineWidth;
            [button setBackgroundColor:WhiteColor];
        }
        [button setFrame:CGRectMake(itemLeft, itemTop, itemWidth, itemHeight)];
        itemLeft = CGRectGetMaxX(button.frame) + 5;
        if (itemWidth + itemLeft > App_Frame_Width) {
            itemLeft = 5;
            itemTop = CGRectGetMaxY(button.frame) + 10;
            row ++;
        }
        
        [button setTag:index];
        [self addSubview:button];
    }
    
    UIButton *completeBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [completeBT setTitle:@"完成" forState:UIControlStateNormal];
    [completeBT setTitleColor:BlackLeverColor5 forState:UIControlStateNormal];
    CGFloat completeWidth = itemHeight * 240 / 42;
    [completeBT setFrame:CGRectMake(5, itemTop + itemHeight + 10, completeWidth, itemHeight)];
    [completeBT setBackgroundColor:WhiteColor];
    [completeBT.layer setCornerRadius:4.];
    [completeBT.layer setBorderWidth:.5];
    [completeBT.layer setBorderColor:BlackLeverColor2.CGColor];
    [completeBT addTarget:self action:@selector(completeClick:) forControlEvents:UIControlEventTouchUpInside];
    [completeBT addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
    [completeBT addTarget:self action:@selector(upOutsideClick:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:completeBT];
    
    UIButton *deleteBT = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBT setImage:[UIImage imageNamed:@"icon_delete_keyboard"] forState:UIControlStateNormal];
    CGFloat deleteWidth = App_Frame_Width - CGRectGetMaxX(completeBT.frame) - 10;
    [deleteBT setFrame:CGRectMake(App_Frame_Width - deleteWidth - 5, completeBT.top, deleteWidth, itemHeight)];
    [deleteBT setBackgroundColor:WhiteColor];
    [deleteBT.layer setCornerRadius:4.];
    [deleteBT.layer setBorderWidth:.5];
    [deleteBT.layer setBorderColor:BlackLeverColor2.CGColor];
    [deleteBT addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    [deleteBT addTarget:self action:@selector(downClick:) forControlEvents:UIControlEventTouchDown];
    [deleteBT addTarget:self action:@selector(upOutsideClick:) forControlEvents:UIControlEventTouchUpOutside];
    [self addSubview:deleteBT];
    
    self.frame = CGRectMake(0, 0, App_Frame_Width, CGRectGetMaxY(completeBT.frame) + 10);
}

@end
