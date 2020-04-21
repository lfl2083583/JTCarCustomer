//
//  NSString+AES256.m
//  Encrypt
//
//  Created by 观潮汇 on 2016/10/22.
//  Copyright © 2016年 观潮汇. All rights reserved.
//

#import "NSString+AES256.h"
#import "NSData+AES256.h"
#import "NSData+Extension.h"

@implementation NSString (AES256)

static NSString *base64_encode_data(NSData *data){
    data = [data base64EncodedDataWithOptions:0];
    NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return ret;
}

static NSData *base64_decode(NSString *str){
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return data;
}

- (NSString *)aes256_encrypt:(NSString *)key
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    //对数据进行加密
    NSData *result = [data aes256_encrypt:key];
    return base64_encode_data(result);
}

- (NSString *)aes256_decrypt:(NSString *)key
{
    //对数据进行解密
    NSMutableData *data = [NSMutableData dataWithCapacity:self.length/2];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i = 0; i < self.length/2; i++) {
        byte_chars[0] = [self characterAtIndex:i*2];
        byte_chars[1] = [self characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    NSData *result = [data aes256_decrypt:key];
    if (result && result.length > 0) {
        return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    }
    return nil;
}
@end
