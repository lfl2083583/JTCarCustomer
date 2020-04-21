//
//  JTImageCollectionViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *imageCollectionIndentifier = @"JTImageCollectionViewCell";

@interface JTImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLB;

@end
