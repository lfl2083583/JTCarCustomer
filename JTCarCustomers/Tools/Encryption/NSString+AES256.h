//
//  NSString+AES256.h
//  Encrypt
//
//  Created by 观潮汇 on 2016/10/22.
//  Copyright © 2016年 观潮汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES256)

- (NSString *)aes256_encrypt:(NSString *)key;
- (NSString *)aes256_decrypt:(NSString *)key;

@end
