//
//  JTPersonQRView.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/31.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTQRCode.h"
#import "JTUserTableViewCell.h"
#import "JTPersonQRView.h"

@implementation JTPersonQRView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.qrView setImage:[ZTQRCode createQRImageWithString:[NSString stringWithFormat:@"http://h5.6che.vip/jump?action=addfriend&userid=%@&t=%@&market=qr", [JTUserInfo shareUserInfo].userID, [Utility currentTime:[NSDate dateWithTimeIntervalSinceNow:0]]] size:self.qrView.size]];
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:[[JTUserInfo shareUserInfo].userAvatar avatarHandleWithSquare:100]] placeholderImage:DefaultSmallAvatar];
    [self.nameLB setText:[JTUserInfo shareUserInfo].userName];
    [self.genderView configGenderView:[JTUserInfo shareUserInfo].userGenter grade:[JTUserTableViewCell caculateBirthWithBirthDate:[JTUserInfo shareUserInfo].userBirth]];
    if ([JTUserInfo shareUserInfo].myCarList.count) {
        JTCarModel *model = [[JTUserInfo shareUserInfo].myCarList firstObject];
        [self.lovecarView sd_setImageWithURL:[NSURL URLWithString:[model.icon avatarHandleWithSquare:30]]];
    }
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, point) && !CGRectContainsPoint(self.avatarView.frame, point) )
    {
        [self dismissViewAnimated:YES completion:nil];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
