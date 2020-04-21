//
//  JTMailTableView.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTMailType)
{
    /** 好友 **/
    JTMailTypeFriends = 0,
    /** 关注 **/
    JTMailTypeFocus,
    /** 粉丝 **/
    JTMailTypeFans,
    /** 群聊 **/
    JTMailTypeTeam,
};

@protocol JTMailTableViewDelegate <NSObject>

- (void)mailTableView:(UITableView *)tableView didSelectAtSession:(NIMSession *)session;

@end

@interface JTMailTableItem : NSObject

@property (nonatomic, copy) NSArray *indexTitles;
@property (nonatomic, copy) NSMutableArray *dataArray;
@property (nonatomic, assign) JTMailType mailType;

@end

@interface JTMailTableView : UITableView

@property (nonatomic, strong) JTMailTableItem *item;
@property (nonatomic, weak) id<JTMailTableViewDelegate> mailTableViewDelegate;

@end
