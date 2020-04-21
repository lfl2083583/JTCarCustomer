//
//  JTTeamMembersTableViewCell.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/20.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTTeamPowerModel.h"

typedef NS_ENUM(NSInteger, JTTeamOperationType) {
    JTTeamOperationTypeAdd,      // 添加群组成员
    JTTeamOperationTypeDel,      // 删除群组成员
};

static NSString *membersIdentifier = @"JTTeamMembersTableViewCell";

@protocol JTTeamMembersTableViewCellDelegate <NSObject>

@optional
/**
 点击用户头像
 
 @param userID 用户ID
 */
- (void)teamDetailMembersCell:(id)membersCell clickTeamUserID:(NSString *)userID;

/**
 群用户删减操作
 
 @param operation 0：是添加 1:是删除
 */
- (void)teamDetailMembersCell:(id)membersCell clickTeamOperation:(JTTeamOperationType)operation;


/**
 加载完成
 */
- (void)teamDetailHeaderViewLoadComplete;

@end

@interface JTTeamMembersTableViewCell : UITableViewCell

@property (nonatomic, strong) NIMSession *session;
@property (nonatomic, strong) JTTeamPowerModel *powerModel;
@property (nonatomic, strong) NSMutableArray *members;
@property (nonatomic, strong) NSMutableArray *showMembers;
@property (nonatomic, assign) BOOL isVisitor;

@property (nonatomic, weak) id<JTTeamMembersTableViewCellDelegate> delegate;

- (void)configMembersWithSession:(NIMSession *)session delegate:(id<JTTeamMembersTableViewCellDelegate>)delegate;
- (void)configMembersWithSession:(NIMSession *)session powerModel:(JTTeamPowerModel *)powerModel delegate:(id<JTTeamMembersTableViewCellDelegate>)delegate;
- (void)configMembersWithSession:(NIMSession *)session teamMembers:(NSArray *)members isVisitor:(BOOL)isVisitor delegate:(id<JTTeamMembersTableViewCellDelegate>)delegate;
+ (CGFloat)getCellHeightWithSession:(NIMSession *)session powerModel:(JTTeamPowerModel *)powerModel isVisitor:(BOOL)isVisitor teamMembersCount:(NSInteger)teamMembersCount;
@end
