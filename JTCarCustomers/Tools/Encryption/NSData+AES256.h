//
//  NSData+AES256.h
//  Encrypt
//
//  Created by 观潮汇 on 2016/10/22.
//  Copyright © 2016年 观潮汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES256)

- (NSData *)aes256_encrypt:(NSString *)key;
- (NSData *)aes256_decrypt:(NSString *)key;

@end
