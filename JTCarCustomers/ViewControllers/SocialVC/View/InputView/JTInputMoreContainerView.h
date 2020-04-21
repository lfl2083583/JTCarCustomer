//
//  JTInputMoreContainerView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTSessionProtocol.h"
#import "JTInputActionDelegate.h"

@interface JTInputMoreContainerView : UIView

@property (nonatomic, weak) id<JTSessionProtocol> inputConfig;
@property (nonatomic, weak) id<JTInputActionDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<JTSessionProtocol>)config
                     delegate:(id<JTInputActionDelegate>)delegate;

@end
