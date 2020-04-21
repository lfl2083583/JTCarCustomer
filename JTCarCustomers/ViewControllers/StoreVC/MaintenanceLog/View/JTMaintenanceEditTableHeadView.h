//
//  JTMaintenanceEditTableHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTMaintenanceEditDelegate <NSObject>

@optional
- (void)maintenanceDateEdite:(id)sender;
- (void)maintenanceMileageEdite:(id)sender;

@end

@interface JTMaintenanceEditTableHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UITextField *mileageTF;
@property (nonatomic, weak) id<JTMaintenanceEditDelegate>delegate;


@end


