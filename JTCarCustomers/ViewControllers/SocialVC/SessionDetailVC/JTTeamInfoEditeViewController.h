//
//  JTTeamInfoEditeViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@protocol JTTeamInfoEditeTableHeadViewDelegate <NSObject>

- (void)changeTeamAvatar;

@end

@interface JTTeamInfoEditeTableHeadView : UIView

@property (nonatomic, strong) UIImageView *bottomImgeView;
@property (nonatomic, strong) UIButton *topBtn;
@property (nonatomic, weak) id<JTTeamInfoEditeTableHeadViewDelegate>delegate;

@end


@interface JTTeamInfoEditeViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;
@property (nonatomic, strong) id loctionInfo;

- (instancetype)initWithTeam:(NIMTeam *)team loctionInfo:(id)loctionInfo;

@end
