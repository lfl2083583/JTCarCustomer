//
//  JTCollectionTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/8/17.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTCirlceImageView.h"
#import "JTCollectionModel.h"
#import "JTGenderGradeImageView.h"

@interface JTCollectionTableViewCell : UITableViewCell

@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UILabel *timeLB;
@property (strong, nonatomic) ZTCirlceImageView *avatarView;
@property (strong, nonatomic) UILabel *nameLB;
@property (strong, nonatomic) JTGenderGradeImageView *genderView;
@property (strong, nonatomic) UIView *horizontalView;

@property (copy, nonatomic) JTCollectionModel *model;

- (void)initSubview;
- (void)setViewAtuoLayout;
@end

