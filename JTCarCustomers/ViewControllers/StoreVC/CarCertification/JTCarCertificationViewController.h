//
//  JTCarCertificationViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTCarCertificationViewController : BaseRefreshViewController

@property (nonatomic, strong) JTCarModel *carModel;
@property (nonatomic, strong) UIImage *licenseImage;

- (instancetype)initCarModel:(JTCarModel *)carModel;

@end
