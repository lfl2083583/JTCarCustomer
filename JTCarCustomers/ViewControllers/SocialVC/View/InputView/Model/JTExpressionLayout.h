//
//  JTExpressionLayout.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTExpressionLayout : NSObject

@property (nonatomic, assign) CGFloat   cellWidth;          //单个单元格宽
@property (nonatomic, assign) CGFloat   cellHeight;         //单个单元格高
@property (nonatomic, assign) CGFloat   imageWidth;         //显示图片的宽
@property (nonatomic, assign) CGFloat   imageHeight;        //显示图片的高

- (instancetype)initWithEmojiLayout;
- (instancetype)initWithPhotoLayout;

@end
