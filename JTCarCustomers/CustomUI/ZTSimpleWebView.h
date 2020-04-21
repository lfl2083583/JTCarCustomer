//
//  ZTSimpleWebView.h
//  GCHCustomerMall
//
//  Created by 观潮汇 on 5/3/16.
//  Copyright © 2016 观潮汇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface ZTSimpleWebView : UIView

@property (weak, nonatomic) id webview;
@property (copy, nonatomic) NSString *urlString;
@property (weak, nonatomic) id<UIScrollViewDelegate> delegate;
@property (weak, nonatomic) id<WKScriptMessageHandler> messageHander;
@property (assign, nonatomic) BOOL isGETALLPHOTO; //获取所有图片 默认YES
@property (copy, nonatomic) UIColor *normalColor;

- (id)initWithFrame:(CGRect)frame urlString:(NSString *)urlString;
- (void)setJavaScriptString:(NSString *)javaScriptString success:(void (^)(id source))success;
@end
