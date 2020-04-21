//
//  JTStoreCommentModel.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTStoreCommentModel : NSObject

@property (copy, nonatomic) NSString *userID;           // 用户ID
@property (copy, nonatomic) NSString *userYuxinID;      // 用户云信ID
@property (copy, nonatomic) NSString *userAvatar;       // 用户头像
@property (copy, nonatomic) NSString *userName;         // 用户昵称
@property (assign, nonatomic) NSInteger userGender;     // 用户性别
@property (assign, nonatomic) NSInteger userGrade;      // 用户等级

@property (copy, nonatomic) NSString *commentID;        // 评论ID
@property (assign, nonatomic) double commentTime;       // 评论时间
@property (copy, nonatomic) NSString *commentScore;     // 评论分数
@property (copy, nonatomic) NSString *commentText;      // 评论内容
@property (copy, nonatomic) NSArray *commentPictures;   // 评论图片
@property (copy, nonatomic) NSString *commentCarModel;  // 评论车型

@property (assign, nonatomic) BOOL replyStatus;         // 是否回复
@property (copy, nonatomic) NSString *replyText;        // 回复内容

@property (assign, nonatomic) CGRect avatarFrame;         // 头像
@property (assign, nonatomic) CGRect titleFrame;          // 标题
@property (assign, nonatomic) CGRect timeFrame;           // 时间
@property (assign, nonatomic) CGRect starFrame;           // 星星
@property (assign, nonatomic) CGRect scoreFrame;          // 分数
@property (assign, nonatomic) CGRect commentFrame;        // 评论内容
@property (copy, nonatomic) NSMutableArray<NSValue *> *imageValues;// 评论图片
@property (assign, nonatomic) CGRect detailFrame;         // 详情
@property (assign, nonatomic) CGRect replyBottomFrame;    // 回复底图
@property (assign, nonatomic) CGRect replyFrame;          // 回复内容


@property (assign, nonatomic) CGFloat cellHeight;

@end
