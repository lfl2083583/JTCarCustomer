//
//  JTInputExpressionCollectionViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/16.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *inputExpressionIdentifier = @"JTInputExpressionCollectionViewCell";

@interface JTInputExpressionCollectionViewCell : UICollectionViewCell

@property (copy, nonatomic) NSString *imageUrlString;
@property (copy, nonatomic) NSString *title;

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *titleLB;

@end
