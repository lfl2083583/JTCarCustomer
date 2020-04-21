//
//  JTTeamMembersViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTTeamMembersHeadView : UIView

@property (nonatomic, strong) UILabel *leftLB;
@property (nonatomic, strong) UILabel *bottomLB;

@end

@interface JTTeamMembersViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;

- (instancetype)initWithTeam:(NIMTeam *)team;

@end
