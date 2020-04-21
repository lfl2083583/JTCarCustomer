//
//  JTMailListModel.m
//  JTSocial
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 JTTeam. All rights reserved.
//
#import "JTMailListModel.h"

@implementation JTMailListModel

+ (instancetype)sharedCenter
{
    static JTMailListModel *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTMailListModel alloc] init];
    });
    return instance;
}

- (void)start
{
    NSLog(@"Notification Center Setup");
}

- (instancetype)init {
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginStatusChangeNotification:) name:kLoginStatusChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoUpdatedNotification:) name:kJTUserInfoUpdatedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamInfoUpdatedNotifacation:) name:kJTTeamMembersUpdatedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(teamInfoUpdatedNotifacation:) name:kJTTeamInfoUpdatedNotification object:nil];
        [self setAllUsers:[[NIMSDK sharedSDK].userManager.myFriends mutableCopy]];
        [self setTeamList:[[NIMSDK sharedSDK].teamManager.allMyTeams mutableCopy]];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginStatusChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTUserInfoUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamMembersUpdatedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kJTTeamInfoUpdatedNotification object:nil];
}

- (void)loginStatusChangeNotification:(NSNotification *)notification
{
    if ([JTUserInfo shareUserInfo].isLogin) {
        [self setAllUsers:[[NIMSDK sharedSDK].userManager.myFriends mutableCopy]];
        [self setTeamList:[[NIMSDK sharedSDK].teamManager.allMyTeams mutableCopy]];
    }
    else
    {
        [self.allUsers removeAllObjects];
        [self.friendMembers removeAllObjects];
        [self.friendTitles removeAllObjects];
        [self.focusMembers removeAllObjects];
        [self.fansMembers removeAllObjects];
        [self.teamList removeAllObjects];
        [self.teamArray removeAllObjects];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(mailListChange)]) {
        [_delegate mailListChange];
    }
}

- (void)userInfoUpdatedNotification:(NSNotification *)notification
{
    [self setAllUsers:[[NIMSDK sharedSDK].userManager.myFriends mutableCopy]];
    if (_delegate && [_delegate respondsToSelector:@selector(mailListChange)]) {
        [_delegate mailListChange];
    }
}

- (void)teamInfoUpdatedNotifacation:(NSNotification *)notification
{
    [self setTeamList:[[NIMSDK sharedSDK].teamManager.allMyTeams mutableCopy]];
    if (_delegate && [_delegate respondsToSelector:@selector(mailListChange)]) {
        [_delegate mailListChange];
    }
}

- (void)addDelegate:(id<JTMailListDelegate>)delegate
{
    _delegate = delegate;
}

- (void)setAllUsers:(NSMutableArray *)allUsers
{
    _allUsers = allUsers;
    [self.friendMembers removeAllObjects];
    [self.friendTitles removeAllObjects];
    [self.focusMembers removeAllObjects];
    [self.fansMembers removeAllObjects];
    if (allUsers.count > 0) {
        [self dealUsers];
    }
}

- (void)setTeamList:(NSMutableArray *)teamList
{
    _teamList = teamList;
    [self.teamArray removeAllObjects];
    if (teamList.count > 0) {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NIMTeam *team in teamList) {
            NSMutableDictionary *teamSource = [NSMutableDictionary dictionary];
            NIMRecentSession *recentSession = [[NIMSDK sharedSDK].conversationManager recentSessionBySession:[NIMSession session:team.teamId type:NIMSessionTypeTeam]];
            NSTimeInterval activeTime;
            if (recentSession) {
                NIMMessage *message = recentSession.lastMessage;
                activeTime = message.timestamp;
            } else {
                activeTime = team.createTime;
            }
            [teamSource setValue:team forKey:@"team"];
            [teamSource setValue:@(activeTime) forKey:@"activeTime"];
            [tempArray addObject:teamSource];
        }
        NSArray *sortArr = [self sortTeamArr:tempArray];
        [self.teamArray addObjectsFromArray:sortArr];
    }
}

- (void)dealUsers
{
    NSArray *sortArray = [self sortUserArr:self.allUsers];
    NSMutableArray *friendsArr = [NSMutableArray array];
    for (NIMUser *user in sortArray) {
        JTUserContactType userType = [JTUserInfoHandle showUserContactType:user];
        if (userType == JTUserContactTypeFocus) {
            [self.focusMembers addObject:user];
        } else if (userType == JTUserContactTypeFans) {
            [self.fansMembers addObject:user];
        } else if (userType == JTUserContactTypeFriends) {
            [friendsArr addObject:user];
        }
    }
    [self dealFriends:friendsArr];
}

- (void)dealFriends:(NSMutableArray *)friends {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 29; i ++) {
        //给临时数组创建27个数组作为元素，用来存放A-Z和#开头的联系人
        [tempArray addObject:[[NSMutableArray alloc] init]];
    }
    for (NIMUser *user in friends) {
        if (![[NIMSDK sharedSDK].userManager isUserInBlackList:user.userId]) {
            int firstWord = [[[JTUserInfoHandle showNick:user.userId] transformToPinyinFirst] characterAtIndex:0];
            if (firstWord >= 65 && firstWord <= 90) {
                //如果首字母是A-Z，直接放到对应数组
                [tempArray[firstWord - 63] addObject:user];
            }
            else
            {
                //如果不是，就放到最后一个代表#的数组
                [[tempArray lastObject] addObject:user];
            }
        }
    }
    
    //此时数据已按首字母排序并分组
    //遍历数组，删掉空数组
    for (NSMutableArray *mutArr in tempArray) {
        //如果数组不为空就添加到数据源当中
        if (mutArr.count != 0) {
            [self.friendMembers addObject:mutArr];
            NIMUser *user = mutArr[0];
            NSString *make;
            make = [[JTUserInfoHandle showNick:user.userId] transformToPinyinFirst];
            int firstWord = [make characterAtIndex:0];
            if (firstWord >= 65 && firstWord <= 90) {
                //如果首字母是A-Z，直接放到对应数组
            }
            else
            {
                //如果不是，就放到最后一个代表#的数组
                make = @"#";
            }
            [self.friendTitles addObject:make];
        }
    }
}

- (NSArray *)sortUserArr:(NSMutableArray *)userArr {
    NSArray *resultArr = [userArr sortedArrayUsingComparator:^NSComparisonResult(NIMUser *obj1, NIMUser *obj2) {
        return [JTUserInfoHandle showFocusTime:obj1] > [JTUserInfoHandle showFocusTime:obj2] ? NSOrderedAscending : NSOrderedDescending;
    }];
    return resultArr;
}

- (NSArray *)sortTeamArr:(NSMutableArray *)teamArr {
    NSArray *resultArr = [teamArr sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [[obj1 objectForKey:@"activeTime"] integerValue] > [[obj2 objectForKey:@"activeTime"] integerValue] ? NSOrderedAscending : NSOrderedDescending;
    }];
    return resultArr;
}

- (NSMutableArray *)friendMembers
{
    if (!_friendMembers) {
        _friendMembers = [NSMutableArray array];
    }
    return _friendMembers;
}

- (NSMutableArray *)friendTitles
{
    if (!_friendTitles) {
        _friendTitles = [NSMutableArray array];
    }
    return _friendTitles;
}

- (NSMutableArray *)focusMembers {
    if (!_focusMembers) {
        _focusMembers = [NSMutableArray array];
    }
    return _focusMembers;
}

- (NSMutableArray *)fansMembers {
    if (!_fansMembers) {
        _fansMembers = [NSMutableArray array];
    }
    return _fansMembers;
}

- (NSMutableArray *)teamArray {
    if (!_teamArray) {
        _teamArray = [NSMutableArray array];
    }
    return _teamArray;
}

@end

