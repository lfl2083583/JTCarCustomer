//
//  JTCreatTeamClassifyViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//


#import "BaseRefreshViewController.h"
#import "JTCreateTeamTitleViewController.h"

static NSString *teamClassfyId = @"JTCreatTeamClassifyCollectionCell";

@interface JTCreatTeamClassifyCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *topImgView;
@property (nonatomic, strong) UILabel *bottomLabel;

- (void)configCellWithTopImge:(UIImage *)image botttomTitle:(NSString *)title isSeleted:(BOOL)flag;

@end

typedef void (^zt_TeamClassifyBlock)(JTTeamCategoryType category);

@interface JTCreatTeamClassifyViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMTeam *team;
@property (nonatomic, copy) zt_TeamClassifyBlock callBack;

- (instancetype)initWithTeamNearby:(JTTeamPositionType)positionType lng:(NSString *)lng lat:(NSString *)lat address:(NSString *)address;

- (instancetype)initWithTeam:(NIMTeam *)team callBack:(zt_TeamClassifyBlock)callBack;

@end
