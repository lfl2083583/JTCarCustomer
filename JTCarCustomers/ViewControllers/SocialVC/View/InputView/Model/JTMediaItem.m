//
//  JTMediaItem.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMediaItem.h"

@implementation JTMediaItem

+ (JTMediaItem *)item:(NSString *)selector
          normalImage:(UIImage *)normalImage
        selectedImage:(UIImage *)selectedImage
                title:(NSString *)title
{
    JTMediaItem *item  = [[JTMediaItem alloc] init];
    item.selctor       = NSSelectorFromString(selector);
    item.normalImage   = normalImage;
    item.selectedImage = selectedImage;
    item.title         = title;
    return item;
}

@end
