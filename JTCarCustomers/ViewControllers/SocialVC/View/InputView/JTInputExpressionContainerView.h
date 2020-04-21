//
//  JTInputExpressionContainerView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTSessionProtocol.h"
#import "JTInputActionDelegate.h"
#import "JTInputExpressionManager.h"

@interface JTInputExpressionContainerView : UIView

@property (nonatomic, weak) id<JTSessionProtocol> inputConfig;
@property (nonatomic, weak) id<JTInputActionDelegate> delegate;
@property (nonatomic, weak) id target;
@property (nonatomic, copy) NSString *didSendMethod;
@property (nonatomic, copy) NSString *didExpressionMethod;

- (instancetype)initWithFrame:(CGRect)frame
                       config:(id<JTSessionProtocol>)config
                     delegate:(id<JTInputActionDelegate>)delegate;

@end
