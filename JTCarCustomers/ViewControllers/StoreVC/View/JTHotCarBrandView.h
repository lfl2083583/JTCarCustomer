//
//  JTHotCarBrandView.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JTHotCarBrandView;

@protocol JTHotCarBrandViewDelegate <NSObject>

- (void)hotCarBrandView:(JTHotCarBrandView *)hotCarBrandView didSelectAtSoucre:(NSDictionary *)source;

@end

@interface JTHotCarBrandView : UIView

@property (weak, nonatomic) id<JTHotCarBrandViewDelegate> delegate;
@property (copy, nonatomic) NSArray *dataArray;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTHotCarBrandViewDelegate>)delegate;

@end
