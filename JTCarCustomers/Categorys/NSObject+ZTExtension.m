//
//  NSObject+Extension.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/29.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "NSObject+ZTExtension.h"

@implementation NSObject (ZTExtension)

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
        [aCoder encodeObject:[self valueForKey:key] forKey:key];
    }
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        unsigned int outCount;
        Ivar *ivars = class_copyIvarList([self class], &outCount);
        for (int i = 0; i < outCount; i ++) {
            Ivar ivar = ivars[i];
            NSString * key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }
    }
    return self;
}

- (NSString *)zt_string
{
    // 不能用base64 因为会产生特殊字符， 也不能对Base64之后的数据URLEncodedString 因为URLEncodedString只会把特殊字符转成% 最后URLDecodedString的时候特殊字符还是变成了空格
    // 也不能直接传data 在url传输的过程中会变成null
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    return [self toBtye:[data bytes] length:[data length]];
}

- (id)zt_object
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self stringToByte:(NSString *)self]];
}

// 数据流转成普通字符串
- (NSString *)toBtye:(const Byte *)bytes length:(NSInteger)length
{
    NSString *hexStr = @"";
    for (int i = 0; i < length; i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x", bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@", hexStr, newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@", hexStr, newHexStr];
    }
    return hexStr;
}

// 普通字符串转成数据流
- (NSData *)stringToByte:(NSString *)string
{
    NSString *hexString = [[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2 != 0)
    {
        return nil;
    }
    Byte tempbyt[1] = {0};
    NSMutableData *bytes=[NSMutableData data];
    for(int i = 0; i < [hexString length]; i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16; //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        
        i++;
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        tempbyt[0] = int_ch1+int_ch2; ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}

@end

