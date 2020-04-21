//
//  JTUserInfoCollectionViewFlowLayout.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTUserInfoCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, assign) NSInteger itemsInRow;

- (instancetype)initWithFrame:(CGRect)frame itemsInRow:(NSInteger)items;

- (void)reloadGrid;

@end
