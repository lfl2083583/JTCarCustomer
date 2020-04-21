//
//  JTTeamQRViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTTeamQRViewController : BaseRefreshViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *qrImgeView;
@property (weak, nonatomic) IBOutlet UIImageView *avatrImgeView;
@property (weak, nonatomic) IBOutlet UILabel *topLB;
@property (weak, nonatomic) IBOutlet UILabel *bottomLB;

@property (nonatomic, strong) NIMTeam *team;

- (instancetype)initWithTeam:(NIMTeam *)team;

@end
