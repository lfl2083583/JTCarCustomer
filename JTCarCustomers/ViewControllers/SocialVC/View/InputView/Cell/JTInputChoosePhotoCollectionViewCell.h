//
//  JTInputChoosePhotoCollectionViewCell.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputPhotoCollectionViewCell.h"

static NSString *inputChoosePhotoIdentifier = @"JTInputChoosePhotoCollectionViewCell";

@interface JTInputChoosePhotoCollectionViewCell : JTInputPhotoCollectionViewCell

@property (strong, nonatomic) UIImageView *bottomIV;
@property (strong, nonatomic) UIButton *choiceBT;
@property (copy, nonatomic) void (^didSelectPhotoBlock)(void);

@end
