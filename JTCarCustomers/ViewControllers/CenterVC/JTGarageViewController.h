//
//  JTGarageViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef void(^BLOCK)();

@interface JTGarageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *topImgeV;
@property (nonatomic, strong) UIImageView *bottomImgeV;
@property (nonatomic, strong) UILabel *bottomLB;

@end


@interface JTGarageViewController : BaseRefreshViewController

@property (assign, nonatomic) BOOL canScroll;
@property (copy, nonatomic) BLOCK block;
@property (strong, nonatomic) UIViewController *parentController;

@end
