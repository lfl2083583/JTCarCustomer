//
//  JTFlowView.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTFlowView : UIView

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) NSInteger currentFlow;

- (instancetype)initImageArray:(NSArray *)imageArray titleArray:(NSArray *)titleArray frame:(CGRect)frame;

@end
