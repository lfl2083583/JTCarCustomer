//
//  JTCategoriesSearchViewController.h
//  JTCarCustomers
//
//  Created by lious on 2018/5/3.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "JTSessionViewController.h"
#import "BaseRefreshViewController.h"
typedef NS_ENUM(NSUInteger, JTSearchType) {
    JTSearchTypeFriends     = 0,//搜索好友
    JTSearchTypeTeams       = 1,//搜索群聊
    JTSearchTypeMessages    = 2,//搜索聊天记录
    JTSearchTypeActivities  = 3,//搜索活动
    
};

@interface JTCategoriesSearchViewController : BaseRefreshViewController

@property (nonatomic, assign) JTSearchType searchType;

@property (nonatomic, copy) NSString *searchKeyword;

- (instancetype)initWithSearchType:(JTSearchType)searchType;

- (instancetype)initWithSearchType:(JTSearchType)searchType originalSource:(id)originalSource searchKeyword:(NSString *)searchKeyword;

- (instancetype)initWithSearchType:(JTSearchType)searchType originalSource:(id)originalSource searchKeyword:(NSString *)searchKeyword messages:(id)messages;
@end
