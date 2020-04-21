//
//  JTTeamManageOperationTableViewCell.h
//  JTSocial
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTUserTableViewCell.h"

typedef enum : NSUInteger {
    TeamBanShowPromptTypeNormal,   // 显示系统箭头
    TeamBanShowPromptTypeTitle,    // 现在提示文字
    TeamBanShowPromptTypeArrow
    
} TeamBanShowPromptType;

static NSString *teamManageOperationIdentifier = @"JTTeamManageOperationTableViewCell";

@interface JTTeamManageOperationTableViewCell : JTUserTableViewCell

@property (strong, nonatomic) UILabel *promptLB;
@property (strong, nonatomic) UIImageView *arrowIV;
@property (assign, nonatomic) TeamBanShowPromptType teamBanShowPromptType;
@property (assign, nonatomic) NSInteger terminalTime;

@end
