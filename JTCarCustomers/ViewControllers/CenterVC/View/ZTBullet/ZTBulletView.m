//
//  ZTBulletView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "ZTBulletView.h"
#import "ZTCirlceImageView.h"

@interface ZTBulletView()

@property(nonatomic, strong) UILabel *lbCommentLabel;
@property(nonatomic, strong) ZTCirlceImageView *lbCommentIcon;

@end

CGFloat static kBulletLabelPadding = 10;

@implementation ZTBulletView

/**
 初始化弹幕

 @param commentInfo 弹幕内容
 @return 弹幕视图
 */
- (instancetype)initWithComment:(NSDictionary *)commentInfo
{
    if(self = [super init])
    {

        self.backgroundColor = RGBCOLOR(0, 0, 0, 0.5);
        NSString *rangeStr = [NSString stringWithFormat:@"%@：", commentInfo[@"nick_name"]];
        NSString *content = [NSString stringWithFormat:@"%@%@", rangeStr ,commentInfo[@"message"]];

        // 计算弹幕文字实际宽度
        NSDictionary *attr = @{
                               NSFontAttributeName:[UIFont systemFontOfSize:16.f]
                               };
        CGSize bulletTextSize = [content sizeWithAttributes:attr];
        
        self.bounds = CGRectMake(0, 0, bulletTextSize.width + 2*kBulletLabelPadding + 25, 30);
        self.layer.cornerRadius = 15;
        self.lbCommentIcon.frame = CGRectMake(2.5, 2.5, 25, 25);
        self.lbCommentLabel.text = content;
        [Utility richTextLabel:self.lbCommentLabel fontNumber:Font(16.f) andRange:[content rangeOfString:rangeStr] andColor:BlueLeverColor4];
        self.lbCommentLabel.frame = CGRectMake(25 + kBulletLabelPadding, kBulletLabelPadding/2, bulletTextSize.width, bulletTextSize.height);
        [self.lbCommentIcon setAvatarByUrlString:[commentInfo[@"avatar"] avatarHandleWithSquare:50] defaultImage:DefaultSmallAvatar];
    }
    return self;
}

/**
 开始动画
 */
- (void)zt_startAnimation
{
    // 根据弹幕长度执行动画效果
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat duration = 8.f;
    CGFloat wholeWidth = screenWidth + CGRectGetWidth(self.bounds) + 50;
    
    // 弹幕开始
    if(self.moveStatusBlock)
    {
        self.moveStatusBlock(Start);
    }
    
    // 根据 v = s/t, 时间固定, 计算速度, 弹幕越长速度越快
    CGFloat speed = wholeWidth/duration;
    
    // 计算完全进入屏幕的时间
    CGFloat enterDuration = (CGRectGetWidth(self.bounds) + [self getRandomNumber:App_Frame_Width/2 to:App_Frame_Width*3/4])/speed;
    
    // 计算完全退出屏幕的时间
    CGFloat exitDuration = wholeWidth/speed;
    
    [self performSelector:@selector(bulletEnterScrren) withObject:nil afterDelay:enterDuration];
    
    // 根据动画改变自身的frame 坐标
    __block CGRect frame = self.frame;
    if (self.trajectory == 1) {
        
        [self setX:App_Frame_Width+60];
        
    } else if (self.trajectory == 2) {
        
        [self setX:App_Frame_Width+120];
    }
    [UIView animateWithDuration:exitDuration delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x -= wholeWidth;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        
        // 调用回调告诉外部状态，方便做下一步处理
        if(self.moveStatusBlock)
        {
            self.moveStatusBlock(Exit);
        }
    }];
}

/**
 结束动画
 */
- (void)zt_stopAnimation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}

/**
 弹幕完全进入屏幕
 */
- (void)bulletEnterScrren
{
    if(self.moveStatusBlock)
    {
        self.moveStatusBlock(Enter);
    }
}

- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

#pragma lazy-load

- (UILabel *)lbCommentLabel
{
    if(!_lbCommentLabel)
    {
        _lbCommentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbCommentLabel.font = Font(16);
        _lbCommentLabel.textColor = WhiteColor;
        [self addSubview:_lbCommentLabel];
    }
    return _lbCommentLabel;
}

- (ZTCirlceImageView *)lbCommentIcon
{
    if(!_lbCommentIcon)
    {
        _lbCommentIcon = [[ZTCirlceImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_lbCommentIcon];
    }
    return _lbCommentIcon;
}

@end
