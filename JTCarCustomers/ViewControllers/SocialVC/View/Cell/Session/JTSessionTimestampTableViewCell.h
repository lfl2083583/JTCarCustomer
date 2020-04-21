//
//  JTSessionTimestampTableViewCell.h
//  JTDirectSeeding
//
//  Created by apple on 2017/5/9.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Chat.h"

@interface JTTimestampModel : NSObject

@property (nonatomic, assign) NSTimeInterval messageTime;
@property (nonatomic, strong) NSString *timeText;

- (instancetype)initWithMessageTime:(NSTimeInterval)messageTime;

@end

static NSString *sessionTimestampIdentifier = @"JTSessionTimestampTableViewCell";

@interface JTSessionTimestampTableViewCell : UITableViewCell

//@property (strong, nonatomic) UIImageView *timeImg;
@property (strong, nonatomic) UILabel *timeLB;
@property (strong, nonatomic) JTTimestampModel *model;

@end
