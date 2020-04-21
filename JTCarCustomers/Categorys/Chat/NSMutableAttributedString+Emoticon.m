//
//  NSMutableAttributedString+Emoticon.m
//  JTDirectSeeding
//
//  Created by apple on 2017/5/18.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "NSMutableAttributedString+Emoticon.h"
#import "JTInputExpressionParser.h"
#import "UIImage+Chat.h"

@implementation NSMutableAttributedString (Emoticon)

- (void)zt_setText:(NSString *)text
{
    NSArray *tokens = [[JTInputExpressionParser currentParser] getTokens:text];
    for (JTInputToken *token in tokens)
    {
        if (token.type == JTInputTokenTypeExpression)
        {
            JTExpression *expression = [[JTInputExpressionManager sharedManager] emojiInName:token.text];
            UIImage *image = [UIImage jt_emoticonInKit:expression.localFileName];
            if (image)
            {
                NSTextAttachment *attach = [[NSTextAttachment alloc] init];
                attach.bounds = CGRectMake(0, -3, 18, 18);
                attach.image = image;
                NSAttributedString *strAtt = [NSAttributedString attributedStringWithAttachment:attach];
                [self insertAttributedString:strAtt atIndex:self.string.length];
            }
        }
        else
        {
            NSAttributedString *strAtt = [[NSAttributedString alloc] initWithString:token.text];
            [self insertAttributedString:strAtt atIndex:self.string.length];
        }
    }
}

@end
