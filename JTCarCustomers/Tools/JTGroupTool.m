//
//  JTGroupTool.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/27.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTGroupTool.h"

@implementation JTGroupTool

- (instancetype)initWithGroupKey:(NSString *)groupKey originalArray:(NSArray *)originalArray
{
    self = [super init];
    if (self) {
        _groupKey = groupKey;
        _originalArray = originalArray;
        [self processingGroup];
    }
    return self;
}

- (void)processingGroup
{
    NSMutableArray *tempArray = [NSMutableArray array];
    [self.titleArray removeAllObjects];
    [self.memberArray removeAllObjects];
    
    for (NSInteger i = 0; i < 27; i ++) {
        //给临时数组创建27个数组作为元素，用来存放A-Z和#开头的联系人
        [tempArray addObject:[[NSMutableArray alloc] init]];
    }
    
    for (NSDictionary *source in self.originalArray) {
        int firstWord = [[[source objectForKey:self.groupKey] transformToPinyinFirst] characterAtIndex:0];
        if (firstWord >= 65 && firstWord <= 90) {
            //如果首字母是A-Z，直接放到对应数组
            [tempArray[firstWord - 65] addObject:source];
        }
        else
        {
            //如果不是，就放到最后一个代表#的数组
            [[tempArray lastObject] addObject:source];
        }
    }
    
    //此时数据已按首字母排序并分组
    //遍历数组，删掉空数组
    for (NSMutableArray *mutArr in tempArray) {
        //如果数组不为空就添加到数据源当中
        if (mutArr.count != 0) {
            [self.memberArray addObject:mutArr];
            NSDictionary *source = mutArr[0];
            NSString *make = [[source objectForKey:self.groupKey] transformToPinyinFirst];
            int firstWord = [make characterAtIndex:0];
            if (firstWord >= 65 && firstWord <= 90) {
                //如果首字母是A-Z，直接放到对应数组
            }
            else
            {
                //如果不是，就放到最后一个代表#的数组
                make = @"#";
            }
            [self.titleArray addObject:make];
        }
    }
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)memberArray
{
    if (!_memberArray) {
        _memberArray = [NSMutableArray array];
    }
    return _memberArray;
}
@end
