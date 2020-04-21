//
//  JTUserInfoCollectionViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JTUserInfoCollectionViewCellDelegate <NSObject>

- (void)collectionViewImgeViewDrag:(UIGestureRecognizer *)recongnizer;

@end

static NSString *userInfoCollectionindentifer = @"JTUserInfoCollectionViewCell";

@interface JTUserInfoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bottomImgeView;
@property (nonatomic, strong) UIImageView *topImgeView;
@property (nonatomic, weak) id<JTUserInfoCollectionViewCellDelegate>delegate;

@end
