//
//  JTMailListModel.h
//  JTSocial
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JTMailListDelegate <NSObject>

@optional
/**
 通讯录改变通知
 */
- (void)mailListChange;

@end

@interface JTMailListModel : NSObject

@property (weak, nonatomic) id<JTMailListDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *allUsers;       // 所有用户
@property (strong, nonatomic) NSMutableArray *friendMembers;  // 好友成员
@property (strong, nonatomic) NSMutableArray *friendTitles;   // 好友标题
@property (strong, nonatomic) NSMutableArray *focusMembers;   // 关注成员
@property (strong, nonatomic) NSMutableArray *fansMembers;    // 粉丝成员
@property (strong, nonatomic) NSMutableArray *teamList;       // 群列表
@property (strong, nonatomic) NSMutableArray *teamArray;

+ (instancetype)sharedCenter;
- (void)start;

- (void)addDelegate:(id<JTMailListDelegate>)delegate;
@end

