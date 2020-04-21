//
//  JTCarCertificationLicenseTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const carCertificationLicenseIdentifier = @"JTCarCertificationLicenseTableViewCell";

@protocol JTCarCertificationLicenseTableViewCellDelegate <NSObject>

- (void)chooseCarSite:(id)sender indexPath:(NSIndexPath *)indexPath;
- (void)carCertificationLicenseShouldBeginEditing:(id)sender indexPath:(NSIndexPath *)indexPath;
- (void)carCertificationLicenseDidEndChangeEditing:(id)sender indexPath:(NSIndexPath *)indexPath;

@end

@interface JTCarCertificationLicenseTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIButton *siteBtn;
@property (nonatomic, strong) UITextField *licenseTF;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<JTCarCertificationLicenseTableViewCellDelegate>delegate;

@end
