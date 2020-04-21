//
//  JTBulletInputView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JTBulletInputView : UIView

@property (nonatomic, strong) UITextField *leftTF;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, copy) NSString *fuid;

- (instancetype)initWithFrame:(CGRect)frame fuid:(NSString *)fuid;

@end
