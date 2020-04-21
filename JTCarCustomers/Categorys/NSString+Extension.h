//
//  NSString+NTES.h
//  NIMDemo
//
//  Created by chris on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSString (Extension)

- (NSString *)MD5String;

- (NSString *)avatarHandleWithSquare:(NSInteger)width;

- (NSString *)avatarHandleWithSize:(CGSize)size;

- (BOOL)isChinese;

- (BOOL)isCodeNumber;

- (BOOL)isMobileNumber;

- (BOOL)isEmail;

- (BOOL)isCarNumber;

- (BOOL)isSpecialCharacter;

- (BOOL)isBlankString;

- (BOOL)isContainsEmoji;

- (BOOL)isIdentity;

- (NSString *)transformToPinyinFirst;

- (NSString *)base64EncodedString;

- (NSString *)base64DecodedString;

- (NSString *)imageLocalPath;

- (NSString *)URLEncodedString;

- (NSString *)URLDecodedString;

+ (NSString *)objectToJSONString:(id)object;
@end
