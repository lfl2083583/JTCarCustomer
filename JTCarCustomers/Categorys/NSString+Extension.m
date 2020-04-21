//
//  NSString+NTES.m
//  NIMDemo
//
//  Created by chris on 15/2/12.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Extension)

- (NSString *)MD5String
{
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)avatarHandleWithSquare:(NSInteger)width
{
    return [self avatarHandleWithSize:CGSizeMake(width, width)];
}

- (NSString *)avatarHandleWithSize:(CGSize)size
{
    if (![self.uppercaseString hasSuffix:@"GIF"]) {
        NSString *avatarUrlString = [[self componentsSeparatedByString:@"?"] firstObject];
        if ([self rangeOfString:@"boshangquan"].location != NSNotFound ||
            [self rangeOfString:@"p53yguagt.bkt.clouddn.com"].location != NSNotFound ||
            [self rangeOfString:@"ofa0vp1fo.bkt.clouddn.com"].location != NSNotFound ||
            [self rangeOfString:@"6che.vip"].location != NSNotFound) {
            avatarUrlString = [avatarUrlString stringByAppendingString:[NSString stringWithFormat:@"?imageView2/5/w/%d/h/%d", (int)size.width, (int)size.height]];
        }
        else
        {
            avatarUrlString = [avatarUrlString stringByAppendingString:[NSString stringWithFormat:@"?imageView&thumbnail=%dz%d", (int)size.width, (int)size.height]];
        }
        return [avatarUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isCodeNumber
{
    NSString *match = @"[0-9]{6}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isMobileNumber
{
    NSString *match = @"[0-9]{11}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isEmail
{
    NSString *match = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isCarNumber
{
    NSString *match = @"^[京津沪渝冀豫云辽黑湘皖鲁新苏浙赣鄂桂甘晋蒙陕吉闽贵粤青藏川宁琼使领A-Z]{1}[A-Z]{1}[A-Z0-9]{4}[A-Z0-9挂学警港澳]{1}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", match];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isSpecialCharacter
{
    NSString *regex = @"[^a-zA-Z0-9\u4E00-\u9FA5,.?:;()!{}<>#*-+=，。、？：；（）！{}+=]➋➌➍➎➏➐➑➒";
    NSRange urgentRange = [self rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString:regex]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

- (BOOL)isBlankString
{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isContainsEmoji
{
    __block BOOL returnValue = NO;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              
                              const unichar hs = [substring characterAtIndex:0];
                              if (0xd800 <= hs && hs <= 0xdbff) {
                                  
                                  if (substring.length > 1) {
                                      const unichar ls = [substring characterAtIndex:1];
                                      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                      
                                      if (0x1d000 <= uc && uc <= 0x1f77f) {
                                          returnValue = YES;
                                      }
                                  }
                                  
                              } else if (substring.length > 1) {
                                  
                                  const unichar ls = [substring characterAtIndex:1];
                                  
                                  if (ls == 0x20e3) {
                                      
                                      returnValue = YES;
                                  }
                                  
                              } else {
                                  if (0x2792 <= hs && hs <= 0x278B) {
                                      
                                      returnValue = YES;
                                      
                                  } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                      
                                      returnValue = YES;
                                      
                                  } else if (0x2934 <= hs && hs <= 0x2935) {
                                      
                                      returnValue = YES;
                                      
                                  } else if (0x3297 <= hs && hs <= 0x3299) {
                                      
                                      returnValue = YES;
                                      
                                  } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                      
                                      returnValue = YES;
                                      
                                  }
                                  
                              }
                          }];
    return returnValue;
}

- (BOOL)isIdentity
{
    if (self.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if (![identityStringPredicate evaluateWithObject:self]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0; i < 17; i++) {
        NSInteger subStrIndex = [[self substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum += subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast = [self substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod == 2) {
        if(![idCardLast isEqualToString:@"X"] || [idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else {
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

- (NSString *)transformToPinyinFirst
{
    NSMutableString *mutStr = [NSMutableString stringWithString:self];
    
    //将mutStr中的汉字转化为带音标的拼音（如果是汉字就转换，如果不是则保持原样）
    CFStringTransform((__bridge CFMutableStringRef)mutStr, NULL, kCFStringTransformMandarinLatin, NO);
    //将带有音标的拼音转换成不带音标的拼音（这一步是从上一步的基础上来的，所以这两句话一句也不能少）
    CFStringTransform((__bridge CFMutableStringRef)mutStr, NULL, kCFStringTransformStripCombiningMarks, NO);
    if (mutStr.length > 0) {
        //全部转换为大写    取出首字母并返回
        NSString *res = [[mutStr uppercaseString] substringToIndex:1];
        return res;
    }
    else
        return @"";
}

- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)imageLocalPath
{
    NSString *fileName;
    if (kIsIphone4s) {
        fileName = @"IP4";
    }
    else if (kIsIphone5) {
        fileName = @"IP5";
    }
    else if (kIsIphone6) {
        fileName = @"IP6";
    }
    else if (kIsIphone6p) {
        fileName = @"IP6+";
    }
    else if (kIsIphonex) {
        fileName = @"IPX";
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    return [path stringByAppendingPathComponent:self];
}

- (NSString *)URLEncodedString
{
    NSString *unencodedString = self;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}


- (NSString *)URLDecodedString
{
    NSString *encodedString = self;
    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                    (__bridge CFStringRef)encodedString,
                                                                                                                    CFSTR(""),
                                                                                                                    CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

+ (NSString *)objectToJSONString:(id)object
{  //去除空格和回车
    NSData *data=[NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"/n" withString:@""];
    return jsonStr;
}

@end
