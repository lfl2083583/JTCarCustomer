//
//  JTStoreCommentModel.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTStoreCommentModel.h"

@implementation JTStoreCommentModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"userID"          : @"user_info.uid",
             @"userYuxinID"     : @"user_info.accid",
             @"userAvatar"      : @"user_info.avatar",
             @"userName"        : @"user_info.nick_name",
             @"userGender"      : @"user_info.gender",
             @"userGrade"       : @"user_info.grade",
             
             @"commentID"       : @"info.comment_id",
             @"commentTime"     : @"info.create_time",
             @"commentScore"    : @"info.score",
             @"commentText"     : @"info.content",
             @"commentPictures" : @"info.pictures",
             @"commentCarModel" : @"info.spec_name",
             
             @"replyStatus"     : @"info.reply_status",
             @"replyText"       : @"info.reply_content",
             };
}

- (CGRect)avatarFrame
{
    if (CGRectEqualToRect(_avatarFrame, CGRectZero)) {
        _avatarFrame = CGRectMake(15, 12, 30, 30);
    }
    return _avatarFrame;
}

- (CGRect)titleFrame
{
    if (CGRectEqualToRect(_titleFrame, CGRectZero)) {
        _titleFrame = CGRectMake(CGRectGetMaxX(self.avatarFrame)+5, self.avatarFrame.origin.y, App_Frame_Width-CGRectGetMaxX(self.avatarFrame)-15, self.avatarFrame.size.height);
    }
    return _titleFrame;
}

- (CGRect)timeFrame
{
    if (CGRectEqualToRect(_timeFrame, CGRectZero)) {
        _timeFrame = CGRectMake(self.avatarFrame.origin.x, CGRectGetMaxY(self.titleFrame)+12, 75, 12);
    }
    return _timeFrame;
}

- (CGRect)starFrame
{
    if (CGRectEqualToRect(_starFrame, CGRectZero)) {
        _starFrame = CGRectMake(CGRectGetMaxX(self.timeFrame)+5, self.timeFrame.origin.y, 50, self.timeFrame.size.height);
    }
    return _starFrame;
}

- (CGRect)scoreFrame
{
    if (CGRectEqualToRect(_scoreFrame, CGRectZero)) {
        _scoreFrame = CGRectMake(CGRectGetMaxX(self.starFrame)+5, self.timeFrame.origin.y, 30, self.timeFrame.size.height);
    }
    return _scoreFrame;
}

- (CGRect)commentFrame
{
    if (CGRectEqualToRect(_commentFrame, CGRectZero)) {
        CGFloat width = App_Frame_Width-2*self.avatarFrame.origin.x;
        CGSize size = [Utility getTextString:self.commentText textFont:Font(16) frameWidth:width attributedString:nil];
        _commentFrame = CGRectMake(self.avatarFrame.origin.x, CGRectGetMaxY(self.timeFrame)+12, size.width, size.height);
    }
    return _commentFrame;
}

- (NSMutableArray<NSValue *> *)imageValues
{
    if (!_imageValues) {
        _imageValues = [NSMutableArray array];
        if (self.commentPictures.count > 0) {
            CGFloat top = CGRectGetMaxY(self.commentFrame)+10;
            CGFloat left = self.avatarFrame.origin.x;
            CGFloat width = 0.0, height = 0.0;
            if (self.commentPictures.count == 1) {
                width = height = 180;
            }
            else if (self.commentPictures.count == 2) {
                width = height = (App_Frame_Width-2*self.avatarFrame.origin.x-5)/2;
            }
            else
            {
                width = height = (App_Frame_Width-2*self.avatarFrame.origin.x-15)/4;
            }
            for (NSInteger index = 0; index < self.commentPictures.count; index ++) {
                CGRect rect = CGRectMake(left, top, width, height);
                [_imageValues addObject:[NSValue valueWithCGRect:rect]];
                left = CGRectGetMaxX(rect) + 5;
                if (left + width > App_Frame_Width) {
                    top = CGRectGetMaxY(rect) + 5;
                    left = self.avatarFrame.origin.x;
                }
            }
        }
    }
    return _imageValues;
}

- (CGRect)detailFrame
{
    if (CGRectEqualToRect(_detailFrame, CGRectZero)) {
        if (self.commentPictures.count > 0) {
            CGRect lastImageRect = [self.imageValues objectAtIndex:self.commentPictures.count-1].CGRectValue;
            _detailFrame = CGRectMake(self.avatarFrame.origin.x, CGRectGetMaxY(lastImageRect)+10, App_Frame_Width-2*self.avatarFrame.origin.x, 12);
        }
        else
        {
            _detailFrame = CGRectMake(self.avatarFrame.origin.x, CGRectGetMaxY(self.commentFrame)+10, App_Frame_Width-2*self.avatarFrame.origin.x, 12);
        }
    }
    return _detailFrame;
}

- (CGRect)replyBottomFrame
{
    if (CGRectEqualToRect(_replyBottomFrame, CGRectZero)) {
        _replyBottomFrame = CGRectMake(self.avatarFrame.origin.x, CGRectGetMaxY(self.detailFrame)+4, App_Frame_Width-2*self.avatarFrame.origin.x, self.replyFrame.size.height+31);
    }
    return _replyBottomFrame;
}

- (CGRect)replyFrame
{
    if (CGRectEqualToRect(_replyFrame, CGRectZero)) {
        CGFloat width = App_Frame_Width-2*self.avatarFrame.origin.x-20;
        CGSize size = [Utility getTextString:self.replyText textFont:Font(16) frameWidth:width attributedString:nil];
        _replyFrame = CGRectMake(self.avatarFrame.origin.x+10, CGRectGetMaxY(self.detailFrame)+25, size.width, size.height);
    }
    return _replyFrame;
}

- (CGFloat)cellHeight
{
    if (_cellHeight == 0) {
        _cellHeight = (self.replyStatus ? CGRectGetMaxY(self.replyBottomFrame) : CGRectGetMaxY(self.detailFrame)) + 15;
    }
    return _cellHeight;
}
@end
