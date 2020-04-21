//
//  JTTeamAnnounceDetailViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/26.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTGradientButton.h"
#import "BaseRefreshViewController.h"

@protocol JTTeamAnnounceDelegate <NSObject>

- (void)announceTableFootViewClick;

@end

@interface JTTeamAnnounceTableHeadView : UIView

@property (nonatomic, strong) UILabel *leftLB;

@end

@interface JTTeamAnnounceTableFootView : UIView

@property (nonatomic, strong) JTGradientButton *centerBtn;
@property (nonatomic, weak) id<JTTeamAnnounceDelegate>delegate;

@end

static NSString *teamAnnounceIndentify = @"JTTeamAnnounceTableViewCell";

@interface JTTeamAnnounceTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *timeLB;
@property (nonatomic, strong) UILabel *rightLB;
@property (nonatomic, strong) UILabel *bottomLB;
@property (nonatomic, strong) UIView *bottomView;

- (void)configCellWithAnnounce:(id)announce;

@end


@interface JTTeamAnnounceDetailViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;

- (instancetype)initWithTeamAnnounce:(id)announce team:(NIMTeam *)team;

@end
