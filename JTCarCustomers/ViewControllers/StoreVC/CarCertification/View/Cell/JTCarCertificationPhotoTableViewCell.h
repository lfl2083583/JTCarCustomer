//
//  JTCarCertificationPhotoTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/21.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const carCertificationPhotoIdentifier = @"JTCarCertificationPhotoTableViewCell";

@protocol JTCarCertificationPhotoTableViewCellDelegate <NSObject>

- (void)recognizeCard:(NSIndexPath *)indexPath;

@end

@interface JTCarCertificationPhotoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UIImageView *bottomView;
@property (nonatomic, strong) UIButton *certificateBtn;

@property (nonatomic, weak) id<JTCarCertificationPhotoTableViewCellDelegate>delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
