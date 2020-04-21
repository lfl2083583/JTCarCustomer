//
//  JTCarCertificationConfirmationTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextViewDelegate.h"

static NSString *const carCertificationConfirmationIdentifier = @"JTCarCertificationConfirmationTableViewCell";

@interface JTCarCertificationConfirmationTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UITextField *detailTF;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<TextViewDelegate>delegate;

@end
