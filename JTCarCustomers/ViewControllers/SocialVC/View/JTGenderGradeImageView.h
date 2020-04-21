//
//  JTGenderGradeImageView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/13.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JTGenderType)
{
    /** 男 **/
    JTGenderMan = 0,
    /** 女 **/
    JTGenderWoman,
};

@interface JTGenderGradeImageView : UIView

- (void)configGenderView:(NIMUserGender)gender grade:(NSInteger)grade;

@end
