//
//  ColorTools.m
//  Bugoo
//
//  Created by cjis on 15/7/17.
//  Copyright (c) 2015年 LoveGuoGuo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Font(size)          [UIFont systemFontOfSize:size]
#define BoldFont(size)      [UIFont boldSystemFontOfSize:size]
#define kFontRatio(size)    (kIsIphone4s ? 0.8*size : (kIsIphone5 ? 0.8*size : (kIsIphone6 ? 0.9*size : 1.0*size)))
#define kScreenRatio        kScreenWidth/750

#define BlueLeverColor1        UIColorFromRGB(0x6987f7)
#define BlueLeverColor2        UIColorFromRGB(0x67a7ff)
#define BlueLeverColor3        UIColorFromRGB(0xf6f8ff)
#define BlueLeverColor4        UIColorFromRGB(0xcad5ff)
#define BlueLeverColor5        UIColorFromRGB(0xb1a3f2)

#define RedLeverColor1        UIColorFromRGB(0xf14b50)
#define RedLeverColor2        UIColorFromRGB(0xffe9e9)

#define WhiteColor           UIColorFromRGB(0xffffff)
#define PurpleColor          UIColorFromRGB(0xc48dfa)
#define YellowColor          UIColorFromRGB(0xf6bb51)
#define GreenColor           UIColorFromRGB(0x53b84b)

#define BlackLeverColor1             UIColorFromRGB(0xf6f6f6)
#define BlackLeverColor2             UIColorFromRGB(0xe6e6e6)
#define BlackLeverColor3             UIColorFromRGB(0x999999)
#define BlackLeverColor4             UIColorFromRGB(0x666666)
#define BlackLeverColor5             UIColorFromRGB(0x444444)
#define BlackLeverColor6             UIColorFromRGB(0x282828)

#define DefaultSmallAvatar      [UIImage imageNamed:@"nav_default"]
#define DefaultBigAvatar        [UIImage imageNamed:@"icon_avatar_default_big"]
