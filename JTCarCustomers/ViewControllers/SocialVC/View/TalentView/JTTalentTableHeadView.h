//
//  JTTalentTableHeadView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/30.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTTalentTableHeadViewDelegate <NSObject>

@optional
- (void)talentTableHeadViewTagClick:(NSString *)tagID;

@end

@interface JTTalentTableHeadView : UIView

@property (nonatomic, strong) NSArray *talentTags;
@property (nonatomic, weak) id<JTTalentTableHeadViewDelegate>delegate;

- (void)reloaData;

+ (CGFloat)getViewHeightWithTags:(NSArray *)tags width:(CGFloat)width;
@end
