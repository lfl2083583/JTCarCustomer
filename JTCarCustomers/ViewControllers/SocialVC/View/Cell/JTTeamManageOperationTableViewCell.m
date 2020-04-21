//
//  JTTeamManageOperationTableViewCell.m
//  JTSocial
//
//  Created by apple on 2017/7/25.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTTeamManageOperationTableViewCell.h"

@implementation JTTeamManageOperationTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.promptLB];
        [self addSubview:self.arrowIV];
    }
    return self;
}

- (UILabel *)promptLB
{
    if (!_promptLB) {
        _promptLB = [[UILabel alloc] init];
        _promptLB.font = Font(12);
        _promptLB.textColor = WhiteColor;
        _promptLB.backgroundColor = BlackLeverColor3;
        _promptLB.textAlignment = NSTextAlignmentCenter;
        _promptLB.frame = CGRectMake(App_Frame_Width-130, 17, 115, 26);
    }
    return _promptLB;
}

- (UIImageView *)arrowIV
{
    if (!_arrowIV) {
        _arrowIV = [[UIImageView alloc] init];
    }
    return _arrowIV;
}

- (void)setTeamBanShowPromptType:(TeamBanShowPromptType)teamBanShowPromptType
{
    _teamBanShowPromptType = teamBanShowPromptType;
    switch (teamBanShowPromptType) {
        case TeamBanShowPromptTypeNormal:
        {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.promptLB.hidden = YES;
            self.promptLB.text = @"";
            self.arrowIV.hidden = YES;
        }
            break;
        case TeamBanShowPromptTypeTitle:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.promptLB.hidden = NO;
            self.arrowIV.hidden = YES;
        }
            break;
        case TeamBanShowPromptTypeArrow:
        {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.promptLB.hidden = YES;
            self.promptLB.text = @"";
            self.arrowIV.hidden = NO;
        }
            break;
        default:
            break;
    }
}

- (void)setTerminalTime:(NSInteger)terminalTime
{
    float timeInterval = terminalTime - [[NSDate date] timeIntervalSince1970];
    if (timeInterval > 0) {
        self.teamBanShowPromptType = TeamBanShowPromptTypeTitle;
        self.promptLB.text = [NSString stringWithFormat:@"已被禁言%d分钟", (int)ceill(timeInterval/60.0)];
    }
    else
    {
        self.teamBanShowPromptType = TeamBanShowPromptTypeNormal;
    }
}

@end
