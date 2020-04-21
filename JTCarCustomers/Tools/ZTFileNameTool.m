//
//  ZTFileNameTool.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "ZTFileNameTool.h"

@implementation ZTFileNameTool

+ (NSArray *)showFileNamesForAvatar
{
    NSMutableArray *fileNames = [NSMutableArray array];
    
    NSString *fileName = [NSString stringWithFormat:@"user/avatar/%@.jpg", [ZTFileNameTool buidRandString]];
    
    [fileNames addObject:fileName];
    return fileNames;
}

+ (NSArray *)showFileNamesForAlbumFileNum:(int)num
{
    NSMutableArray *fileNames = [NSMutableArray array];
    
    for (int i = 0; i < num; i++) {
        
        NSString *fileName = [NSString stringWithFormat:@"user/album/%@.jpg", [ZTFileNameTool buidRandString]];
        
        [fileNames addObject:fileName];
    }
    return fileNames;
}

+ (NSArray *)showFileNamesForVeriFileNum:(int)num
{
    NSMutableArray *fileNames = [NSMutableArray array];
    
    for (int i = 0; i < num; i++) {
        //1:正面 2:反面 3:手持
        NSString *fileName = [NSString stringWithFormat:@"user/verifie/%@/card_pic_%d.jpg", [ZTFileNameTool buidRandString], i];
        
        [fileNames addObject:fileName];
    }
    return fileNames;
}

+ (NSArray *)showFileNamesForTeamAvatar
{
    NSMutableArray *fileNames = [NSMutableArray array];
    
    NSString *fileName = [NSString stringWithFormat:@"group/avatar/%@.jpg", [self buidRandString]];
    
    [fileNames addObject:fileName];
    return fileNames;
}

+ (NSArray *)showFileNamesForTeamAlbumFileNum:(int)num
{
    NSMutableArray *fileNames = [NSMutableArray array];
    
    for (int i = 0; i < num; i++) {
       
        NSString *fileName = [NSString stringWithFormat:@"group/album/%@.jpg", [ZTFileNameTool buidRandString]];
        
        [fileNames addObject:fileName];
        
    }
    return fileNames;
}

+ (NSArray *)showFileNamesForCarAuthFileNum:(int)num
{
    
    NSMutableArray *fileNames = [NSMutableArray array];
    
    for (int i = 0; i < num; i++) {
        //1:行驶证 2:身份证
        NSString *fileName = [NSString stringWithFormat:@"user/carauth/%@/card_pic_%d.jpg", [ZTFileNameTool buidRandString], i];
        
        [fileNames addObject:fileName];
    }
    return fileNames;
}

+ (NSArray *)showFileNamesForVeriComplainFileNum:(int)num
{
    NSMutableArray *fileNames = [NSMutableArray array];
    
    for (int i = 0; i < num; i++) {
        //1:正面 2:反面 3:手持
        NSString *fileName = [NSString stringWithFormat:@"user/appeal/%@/card_pic_%d.jpg", [ZTFileNameTool buidRandString], i];
        
        [fileNames addObject:fileName];
    }
    return fileNames;
}

+ (NSString *)buidRandString {
    
    NSDate *avatarDate = [NSDate date];
    
    NSDateFormatter *avatarFormate = [[NSDateFormatter alloc] init];
    
    [avatarFormate setDateFormat:@"yyyy/MM/dd"];
    
    NSString *time = [avatarFormate stringFromDate:avatarDate];
    
    return [NSString stringWithFormat:@"%@/%@/%ld", [JTUserInfo shareUserInfo].userID,  time, arc4random()%10000000000+1];
}

@end
