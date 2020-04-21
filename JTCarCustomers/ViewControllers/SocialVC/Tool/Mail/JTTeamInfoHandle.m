//
//  JTTeamInfoHandle.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/24.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
 
#import "JTTeamInfoHandle.h"

@implementation JTTeamInfoHandle

+ (JTTeamCategoryType)showTeamCategoryWithTeam:(NIMTeam *)team {
    JTTeamCategoryType category = JTTeamCategoryTypeCarFriend;
    if (team) {
        if (team.serverCustomInfo && [team.serverCustomInfo isKindOfClass:[NSString class]]) {
            NSDictionary *ext = [NSJSONSerialization JSONObjectWithData:[team.serverCustomInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSString *str = [ext objectForKey:@"category"];
            if (str && [str isKindOfClass:[NSString class]]) {
                category = [str integerValue];
            }
        }
    }
    return category;
}

+ (UIImage *)showTeamCategoryImage:(JTTeamCategoryType)categoryTyoe {
    UIImage *image;
    switch (categoryTyoe) {
        case JTTeamCategoryTypeCarFriend:
            image = [UIImage imageNamed:@"team_carfriend_category"];
            break;
        case JTTeamCategoryTypeSport:
            image = [UIImage imageNamed:@"team_sports_category"];
            break;
        case JTTeamCategoryTypeMakeFriend:
            image = [UIImage imageNamed:@"team_makefriends_category"];
            break;
        case JTTeamCategoryTypePlay:
            image = [UIImage imageNamed:@"team_play_category"];
            break;
        case JTTeamCategoryTypeLive:
            image = [UIImage imageNamed:@"team_live_category"];
            break;
        case JTTeamCategoryTypeGame:
            image = [UIImage imageNamed:@"team_game_category"];
            break;
        case JTTeamCategoryTypeTheSameCity:
            image = [UIImage imageNamed:@"team_city_category"];
            break;
        case JTTeamCategoryTypeInterest:
            image = [UIImage imageNamed:@"team_interest_category"];
            break;
        default:
            break;
    }
    return image;
}
@end
