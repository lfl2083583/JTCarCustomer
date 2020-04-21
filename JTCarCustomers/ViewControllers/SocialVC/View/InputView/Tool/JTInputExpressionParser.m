//
//  JTInputExpressionParser.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTInputExpressionParser.h"

@implementation JTInputToken

@end

@interface JTInputExpressionParser ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation JTInputExpressionParser

+ (instancetype)currentParser
{
    static JTInputExpressionParser *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JTInputExpressionParser alloc] init];
    });
    return instance;
}

- (NSArray *)getTokens:(NSString *)text
{
    if (text.length == 0) {
        return nil;
    }
    if ([self.cache objectForKey:text]) {
        return [self.cache objectForKey:text];
    }
    else
    {
        NSArray *tokens = [self parseToken:text];
        if (tokens) {
            [self.cache setObject:tokens forKey:text];
        }
        return tokens;
    }
}

- (NSArray *)parseToken:(NSString *)text
{
    NSMutableArray *tokens = [NSMutableArray array];
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:@"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]"
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
    __block NSInteger index = 0;
    [exp enumerateMatchesInString:text
                          options:0
                            range:NSMakeRange(0, [text length])
                       usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                           NSString *rangeText = [text substringWithRange:result.range];
                           if ([[JTInputExpressionManager sharedManager] emojiInName:rangeText])
                           {
                               if (result.range.location > index)
                               {
                                   NSString *rawText = [text substringWithRange:NSMakeRange(index, result.range.location - index)];
                                   JTInputToken *token = [[JTInputToken alloc] init];
                                   token.type = JTInputTokenTypeText;
                                   token.text = rawText;
                                   [tokens addObject:token];
                               }
                               JTInputToken *token = [[JTInputToken alloc] init];
                               token.type = JTInputTokenTypeExpression;
                               token.text = rangeText;
                               [tokens addObject:token];

                               index = result.range.location + result.range.length;
                           }
                       }];
    
    if (index < [text length])
    {
        NSString *rawText = [text substringWithRange:NSMakeRange(index, [text length] - index)];
        JTInputToken *token = [[JTInputToken alloc] init];
        token.type = JTInputTokenTypeText;
        token.text = rawText;
        [tokens addObject:token];
    }
    return tokens;
}

- (NSCache *)cache
{
    if (!_cache) {
        _cache = [[NSCache alloc] init];
    }
    return _cache;
}

@end
