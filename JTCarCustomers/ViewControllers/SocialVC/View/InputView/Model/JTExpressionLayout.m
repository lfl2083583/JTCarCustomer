//
//  JTExpressionLayout.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionLayout.h"
#import "JTInputGlobal.h"

@implementation JTExpressionLayout

- (instancetype)initWithEmojiLayout
{
    self = [super init];
    if (self) {
        _cellWidth = JTKit_EmojCellHeight;
        _cellHeight = JTKit_EmojCellWidth;
        _imageWidth = JTKit_EmojImageHeight;
        _imageHeight = JTKit_EmojImageWidth;
    }
    return self;
}

- (instancetype)initWithPhotoLayout
{
    self = [super init];
    if (self) {
        _cellWidth = JTKit_PhotoCellWidth;
        _cellHeight = JTKit_PhotoCellHeight;
        _imageWidth = JTKit_PhotoImageHeight;
        _imageHeight = JTKit_PhotoImageWidth;
    }
    return self;
}
@end
