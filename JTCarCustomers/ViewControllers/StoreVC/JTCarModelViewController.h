//
//  JTCarModelViewController.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

@class JTCarModelViewController;

@protocol JTCarModelViewControllerDelegate <NSObject>

- (void)carModelViewController:(JTCarModelViewController *)carModelViewController didSelectAtSource:(NSDictionary *)source;

@end

@interface JTCarModelViewController : BaseRefreshViewController

@property (weak, nonatomic) id<JTCarModelViewControllerDelegate> delegate;

- (instancetype)initWithDelegate:(id<JTCarModelViewControllerDelegate>)delegate;

@end
