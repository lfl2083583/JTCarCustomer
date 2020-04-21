//
//  JTCarCertificationConfirmationViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface JTCarCertificationConfirmationViewController : BaseRefreshViewController

@property (nonatomic, strong) UIImage *licenceImge;
@property (nonatomic, strong) id result;
@property (nonatomic, strong) JTCarModel *carModel;

- (instancetype)initWithLicenceImge:(UIImage *)licenceImge result:(id)result carModel:(JTCarModel *)carModel;

@end
