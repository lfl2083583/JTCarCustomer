//
//  JTActivityShareView.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/5.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ZT_ActivityShareBlock)(NSError *error);
@interface JTActivityShareView : UIView

@property (nonatomic, copy) id activityInfo;
@property (nonatomic, copy) ZT_ActivityShareBlock callBack;

- (instancetype)initWithActivityInfo:(id)activityInfo;

@end
