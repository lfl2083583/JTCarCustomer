//
//  JTChoosePhotoCollectionViewCell.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/11.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *choosePhotoIdentifier = @"JTChoosePhotoCollectionViewCell";

@interface JTChoosePhotoCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *photo;
@property (strong, nonatomic) UIImageView *markIcon;
@property (copy, nonatomic) void (^didSelectPhotoBlock)(void);

@end
