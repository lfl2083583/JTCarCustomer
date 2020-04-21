//
//  JTContactConfig.m
//  JTSocial
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "JTContactConfig.h"
#import "JTMailListModel.h"

@implementation JTContactFriendConfig : NSObject

- (JTContactSelectType)selectType
{
    return self.contactSelectType;
}

- (NSString *)title {
    return @"选择好友";
}

- (NSInteger)maxSelectedNum {
    if (self.needMutiSelected) {
        return NSIntegerMax;
    } else {
        return 1;
    }
}

- (NSString *)selectedOverFlowTip {
    return @"选择超限";
}

- (NSMutableArray *)groupMember {
    if (!_groupMember) {
        _groupMember = [NSMutableArray array];
        for (NSArray *array in [JTMailListModel sharedCenter].friendMembers) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NIMUser *user in array) {
                NSDictionary *source = @{@"avatar": [NSString stringWithFormat:@"%@", user.userInfo.avatarUrl], @"name": [JTUserInfoHandle showNick:user.userId], @"yunxinID": user.userId, @"userID":[JTUserInfoHandle showUserId:user]};
                [tempArray addObject:source];
            }
            [_groupMember addObject:tempArray];
        }
    }
    return _groupMember;
}

- (NSArray *)groupTitle {
    return [JTMailListModel sharedCenter].friendTitles;
}

@end

@implementation JTContactTeamMemberConfig : NSObject

- (JTContactSelectType)selectType
{
    return self.contactSelectType;
}

- (NSString *)title {
    return @"选择联系人";
}

- (NSInteger)maxSelectedNum {
    if (self.needMutiSelected) {
        return NSIntegerMax;
    } else {
        return 1;
    }
}

- (NSString *)selectedOverFlowTip {
    return @"选择超限";
}

- (void)setMembers:(NSArray *)members
{
    _members = members;    
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.groupMember removeAllObjects];
    [self.groupTitle removeAllObjects];
    
    for (NSInteger i = 0; i < 27; i ++) {
        //给临时数组创建27个数组作为元素，用来存放A-Z和#开头的联系人
        [tempArray addObject:[[NSMutableArray alloc] init]];
    }
    for (NIMTeamMember *member in members) {
        if ((![member.userId isEqualToString:[JTUserInfo shareUserInfo].userYXAccount] && !self.showAllMember) || self.showAllMember) {
            
            NIMUser *user = [[NIMSDK sharedSDK].userManager userInfo:member.userId];
            NSString *userName = [JTUserInfoHandle showNick:user member:member];
            NSDictionary *source = @{@"avatar": [NSString stringWithFormat:@"%@", user.userInfo.avatarUrl], @"name": userName, @"yunxinID": user.userId, @"userID":[JTUserInfoHandle showUserId:user]};
            int firstWord = [[userName transformToPinyinFirst] characterAtIndex:0];
            if (firstWord >= 65 && firstWord <= 90) {
                //如果首字母是A-Z，直接放到对应数组
                [tempArray[firstWord - 65] addObject:source];
            }
            else
            {
                //如果不是，就放到最后一个代表#的数组
                [[tempArray lastObject] addObject:source];
            }
        }
    }
    
    //此时数据已按首字母排序并分组
    //遍历数组，删掉空数组
    for (NSMutableArray *mutArr in tempArray) {
        //如果数组不为空就添加到数据源当中
        if (mutArr.count != 0) {
            [self.groupMember addObject:mutArr];
            NSDictionary *source = mutArr[0];
            NSString *make = [source[@"name"] transformToPinyinFirst];
            int firstWord = [make characterAtIndex:0];
            if (firstWord >= 65 && firstWord <= 90) {
                //如果首字母是A-Z，直接放到对应数组
            }
            else
            {
                //如果不是，就放到最后一个代表#的数组
                make = @"#";
            }
            [self.groupTitle addObject:make];
        }
    }
}

- (NSMutableArray *)groupMember
{
    if (!_groupMember) {
        _groupMember = [NSMutableArray array];
    }
    return _groupMember;
}

- (NSMutableArray *)groupTitle
{
    if (!_groupTitle) {
        _groupTitle = [NSMutableArray array];
    }
    return _groupTitle;
}

@end
