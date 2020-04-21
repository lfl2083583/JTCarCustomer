//
//  JTBanCoverView.h
//  JTCarCustomers
//
//  Created by jt on 2018/4/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTBanCoverViewDelegate <NSObject>

- (void)banCoverViewToCancel:(id)banCoverView;

@end

@interface JTBanCoverView : UILabel
{
    dispatch_source_t timer;
}

@property (assign, nonatomic) double timeInterval;
@property (weak, nonatomic) id<JTBanCoverViewDelegate> delegate;

@end
