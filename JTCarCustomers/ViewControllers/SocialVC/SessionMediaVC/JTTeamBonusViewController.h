//
//  JTTeamBonusViewController.h
//  JTSocial
//
//  Created by apple on 2017/7/13.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^bonusSendSuccessBlock)(void);

@interface JTTeamBonusViewController : UIViewController

@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, copy) bonusSendSuccessBlock successBlock;

- (instancetype)initWithSession:(NIMSession *)session;

@end
