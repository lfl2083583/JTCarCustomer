//
//  JTExpressionAttachment.m
//  JTCarCustomers
//
//  Created by apple on 2018/3/6.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTExpressionAttachment.h"

@implementation JTExpressionAttachment

- (instancetype)initWithExpressionID:(NSString *)expressionID expressionName:(NSString *)expressionName expressionUrl:(NSString *)expressionUrl expressionThumbnail:(NSString *)expressionThumbnail expressionWidth:(NSString *)expressionWidth expressionHeight:(NSString *)expressionHeight
{
    self = [super init];
    if (self) {
        _expressionId = expressionID;
        _expressionName = expressionName;
        _expressionUrl = expressionUrl;
        _expressionThumbnail = expressionThumbnail;
        _expressionWidth = expressionWidth;
        _expressionHeight = expressionHeight;
    }
    return self;
}

- (NSString *)encodeAttachment
{
    NSDictionary *dict = @{
                           CMType : @( CustomMessageTypeExpression ),
                           CMData : @{ CMExpressionId : self.expressionId?self.expressionId : @"",
                                       CMExpressionName : self.expressionName?self.expressionName : @"",
                                       CMExpressionUrl : self.expressionUrl?self.expressionUrl : @"",
                                       CMExpressionThumbnail : self.expressionThumbnail?self.expressionThumbnail : @"",
                                       CMExpressionWidht : self.expressionWidth?self.expressionWidth : @"",
                                       CMExpressionHeight : self.expressionHeight?self.expressionHeight : @""
                                       }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:0
                                                     error:nil];
    NSString *content = nil;
    if (data) {
        content = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    }
    return content;
}

- (CGSize)contentSize:(NIMMessage *)message
{
    if (self.expressionWidth && self.expressionWidth.length && self.expressionHeight && self.expressionHeight.length) {
        
        CGFloat attachmentImageMinWidth  = 40;
        CGFloat attachmentImageMinHeight = 40;
        CGFloat attachmemtImageMaxWidth  = 150*[UIScreen mainScreen].bounds.size.width/375;
        CGFloat attachmentImageMaxHeight = 150*[UIScreen mainScreen].bounds.size.width/375;
        
        CGSize imageSize = CGSizeMake([self.expressionWidth floatValue], [self.expressionHeight floatValue]);
        CGSize turnImageSize = [UIImage jt_sizeWithImageOriginSize:imageSize
                                                           minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                                           maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
        return CGSizeMake(turnImageSize.width+4, turnImageSize.height+4);
    }
    else
    {
        return CGSizeMake(80, 80);
    }
}

@end
