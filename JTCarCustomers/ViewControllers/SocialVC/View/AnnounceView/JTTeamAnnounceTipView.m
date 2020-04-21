//
//  JTTeamAnnounceTipView.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/17.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIView+Spring.h"
#import "JTTeamAnnounceTipView.h"
#import "JTTeamAnnounceDetailViewController.h"

@interface JTTeamAnnounceTipView ()

@end

@implementation JTTeamAnnounceTipView

- (void)dealloc {
    CCLOG(@"JTTeamAnnounceTipView销毁了");
}

- (instancetype)initWithAnnounce:(id)announce
{
    self = [super initWithFrame:CGRectMake(0, 0, App_Frame_Width, APP_Frame_Height)];
    if (self) {
        _announce = announce;
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = RGBCOLOR(0, 0, 0, 0.6);
    self.contentView = [[UIView alloc] init];
    self.contentView.layer.cornerRadius = 4;
    self.contentView.layer.masksToBounds = YES;
    self.contentView.backgroundColor = WhiteColor;
    [self addSubview:self.contentView];
    
    self.titleLB = [[UILabel alloc] init];
    self.titleLB.font = Font(16);
    self.titleLB.textColor = BlackLeverColor6;
    self.titleLB.text = @"群公告";
    [self.contentView addSubview:self.titleLB];
    
    self.timeLB = [[UILabel alloc] init];
    self.timeLB.font = Font(12);
    self.timeLB.textColor = BlackLeverColor3;
    [self.contentView addSubview:self.timeLB];
    
    self.readLB = [[UILabel alloc] init];
    self.readLB.font = Font(12);
    self.readLB.textColor = BlueLeverColor1;
    self.readLB.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.readLB];
    
    self.horizontalView = [[UIView alloc] init];
    self.horizontalView.backgroundColor = BlackLeverColor2;
    [self.contentView addSubview:self.horizontalView];
    
    self.contentLB = [[UILabel alloc] init];
    self.contentLB.font = Font(16);
    self.contentLB.numberOfLines = 0;
    self.contentLB.textColor = BlackLeverColor6;
    [self.contentView addSubview:self.contentLB];
    
    self.centerBtn = [[JTGradientButton alloc] init];
    [self.centerBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [self.centerBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.centerBtn.titleLabel setFont:Font(18)];
    [self.centerBtn addTarget:self action:@selector(centerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.centerBtn];
    
    self.moreBtn = [[UIButton alloc] init];
    [self.moreBtn setTitle:@"查看更多群公告" forState:UIControlStateNormal];
    [self.moreBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
    [self.moreBtn.titleLabel setFont:Font(14)];
    [self.moreBtn addTarget:self action:@selector(moreBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.moreBtn];
    
    CGFloat width = App_Frame_Width*(325.0/375.0);
    CGSize size = [Utility getTextString:self.announce[@"content"] textFont:Font(16) frameWidth:width-52 attributedString:nil];
    CGFloat textHeight = size.height>86?86:size.height;
    
    [self.titleLB setFrame:CGRectMake(20, 15, width, 20)];
    [self.timeLB setFrame:CGRectMake(20, CGRectGetMaxY(self.titleLB.frame), 150, 20)];
    [self.readLB setFrame:CGRectMake(width-168, CGRectGetMaxY(self.titleLB.frame), 150, 20)];
    [self.horizontalView setFrame:CGRectMake(0, CGRectGetMaxY(self.timeLB.frame)+5, width, 0.5)];
    [self.contentLB setFrame:CGRectMake(26, CGRectGetMaxY(self.horizontalView.frame)+20, width-52, textHeight)];
    [self.centerBtn setFrame:CGRectMake((width-120)/2.0, CGRectGetMaxY(self.contentLB.frame)+20, 120, 45)];
    [self.moreBtn setFrame:CGRectMake((width-120)/2.0, CGRectGetMaxY(self.centerBtn.frame)+17, 120, 20)];
    
    CGFloat contentHeight = CGRectGetMaxY(self.moreBtn.frame)+26;
    [self.contentView setFrame:CGRectMake((App_Frame_Width-width)/2.0, (APP_Frame_Height-contentHeight)/2.0, width, contentHeight)];
    
    self.timeLB.text = self.announce[@"create_time"];
    self.readLB.text = [NSString stringWithFormat:@"%@人已读", self.announce[@"number"]];
    self.contentLB.text = self.announce[@"content"];
    
    UITapGestureRecognizer *tapGuester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreBtnClick)];
    self.contentLB.userInteractionEnabled = YES;
    [self.contentLB addGestureRecognizer:tapGuester];
}

- (void)centerBtnClick {
    [self dismissViewAnimated:YES completion:nil];
}

- (void)moreBtnClick {
    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:[NSString stringWithFormat:@"%@", self.announce[@"group_id"]]];
    if (team) {
        [self dismissViewAnimated:YES completion:nil];
        [[Utility currentViewController].navigationController pushViewController:[[JTTeamAnnounceDetailViewController alloc] initWithTeamAnnounce:self.announce team:team] animated:YES];
    }
}


@end
