//
//  JTPersonQRView.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/31.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Spring.h"
#import "JTGenderGradeImageView.h"

@interface JTPersonQRView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UIImageView *qrView;
@property (weak, nonatomic) IBOutlet JTGenderGradeImageView *genderView;
@property (weak, nonatomic) IBOutlet UIImageView *lovecarView;


@end
