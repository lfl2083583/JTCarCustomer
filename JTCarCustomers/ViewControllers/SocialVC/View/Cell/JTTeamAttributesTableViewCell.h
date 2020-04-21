//
//  JTTeamAttributesTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *attributeCellIdentifier = @"JTTeamAttributesCollectionCell";

@interface JTTeamAttributesCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *centerLB;
@property (nonatomic, strong) UILabel *bottomLB;

- (void)configCellWithProgress:(CGFloat)progress strokeColor:(UIColor *)strokeColor title:(NSString *)title;

@end

@interface JTTeamAttributesTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *topLB;

@property (nonatomic, strong) NSArray *propertys;

@end
