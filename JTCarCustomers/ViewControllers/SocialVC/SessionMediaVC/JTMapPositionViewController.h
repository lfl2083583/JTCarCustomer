//
//  JTMapPositionViewController.h
//  JTSocial
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "BaseRefreshViewController.h"

typedef NS_ENUM(NSInteger, JTMapType) {
    JTMapTypeSession,
    JTMapTypeCreateGroup,
};

@interface JTMapPositionViewController : BaseRefreshViewController

typedef void(^JTMapPositionViewControllerBlock)(NIMMessage *message);

@property (nonatomic, copy) JTMapPositionViewControllerBlock mapPositionViewControllerBlock;
@property (nonatomic, copy) NSString *place;
@property (nonatomic, assign) JTMapType mapType;

- (instancetype)initWithPlace:(NSString *)place mapType:(JTMapType)mapType;

@end
