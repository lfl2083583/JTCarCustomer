//
//  JTInputAlbumContainerView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTInputActionDelegate.h"

@interface JTInputAlbumContainerView : UIView

@property (nonatomic, weak) id<JTInputActionDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<JTInputActionDelegate>)delegate;
@end
