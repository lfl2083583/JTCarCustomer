//
//  JTMaintenanceEditTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/18.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const maintenanceEditIdentifier = @"JTMaintenanceEditTableViewCell";

static NSString *const maintenanceReusableIdentifier = @"JTMaintenanceReusableview";

static NSString *const maintenanceEditColectionIdentifier = @"JTMaintenanceEditColectionViewCell";

@interface JTMaintenanceReusableview : UICollectionReusableView

@property (nonatomic, strong) UILabel *titleLB;

@end

@interface JTMaintenanceEditColectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *titleLB;

@end

@interface JTMaintenanceEditTableViewCell : UITableViewCell

@end
