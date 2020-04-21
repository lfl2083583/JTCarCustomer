//
//  JTGarageDynamicContainerViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/1.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "FJSlidingController.h"
@protocol JTGarageDynamicContainerViewControllerDelegate <NSObject>

- (void)callBack;

@end

static NSString *garageDynamicCellIdentifier = @"JTGarageDynamicContainerTableViewCell";

@interface JTGarageDynamicContainerViewController : FJSlidingController

@property (weak, nonatomic) UIViewController *parentController;
@property (weak, nonatomic) id <JTGarageDynamicContainerViewControllerDelegate>delegate;

@end


