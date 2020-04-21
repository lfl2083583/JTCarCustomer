//
//  JTTeamAnnounceTipView.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/17.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTGradientButton.h"

@interface JTTeamAnnounceTipView : UIView

@property (nonatomic, strong) JTGradientButton *centerBtn;
@property (nonatomic, strong) UIView *horizontalView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *contentLB;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *readLB;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) id announce;

- (instancetype)initWithAnnounce:(id)announce;
@end
