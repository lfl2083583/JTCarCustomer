//
//  ZTBullet.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/19.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "ZTBullet.h"

@implementation ZTBullet

/**
 弹幕管理器
 */
+ (ZTBulletManager *)manager
{
    return [ZTBulletManager sharedInstance];
}

@end
