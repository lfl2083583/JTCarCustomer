//
//  JTTeamNikeNameViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTTextField.h"
#import "BaseRefreshViewController.h"

@interface JTTeamNikeNameTableHeadView : UIView

@property (nonatomic, strong) UILabel *topLB;

@end

@interface JTTeamNikeNameTableFootView : UIView

@property (nonatomic, strong) ZTTextField *textField;

@end

@interface JTTeamNikeNameViewController : BaseRefreshViewController

@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, strong) NSString *userName;

- (instancetype)initWithSession:(NIMSession *)session userNick:(NSString *)userName;

@end
