//
//  JTMediaItem.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JTMediaItem : NSObject

@property (nonatomic, assign) SEL selctor;

@property (nonatomic, strong) UIImage *normalImage;

@property (nonatomic, strong) UIImage *selectedImage;

@property (nonatomic, copy) NSString *title;

+ (JTMediaItem *)item:(NSString *)selector
          normalImage:(UIImage *)normalImage
        selectedImage:(UIImage *)selectedImage
                title:(NSString *)title;

@end
