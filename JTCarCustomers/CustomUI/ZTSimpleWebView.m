//
//  ZTSimpleWebView.m
//  GCHCustomerMall
//
//  Created by 观潮汇 on 5/3/16.
//  Copyright © 2016 观潮汇. All rights reserved.
//

#import "ZTSimpleWebView.h"
#import "MWPhotoBrowser.h"

@interface ZTSimpleWebView () <WKNavigationDelegate, UIWebViewDelegate, MWPhotoBrowserDelegate>
{
    NSURLCache *urlCache;
}
@property (strong, nonatomic) UIActivityIndicatorView *activity;
@property (strong, nonatomic) NSArray *tempImages;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) UINavigationController *photoNavigationController;
@property (strong, nonatomic) WKWebViewConfiguration *config;
@property (strong, nonatomic) UIProgressView *progressView;
@end

@implementation ZTSimpleWebView

- (UIActivityIndicatorView *)activity
{
    if (_activity == nil) {
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activity sizeToFit];
        _activity.center = self.center;
        _activity.hidden = YES;
    }
    return _activity;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.frame.size.width, 2);
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 2.0f);
        _progressView.progressTintColor = BlueLeverColor1;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    }
    return _progressView;
}

- (id)initWithFrame:(CGRect)frame urlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        _isGETALLPHOTO = NO;
        [self createUI];
        [self setUrlString:urlString];
    }
    return self;
}

- (void)dealloc
{
    if (IOS8) {
        [(WKWebView *)_webview scrollView].delegate = nil;
        [self.config.userContentController removeScriptMessageHandlerForName:@"iosDownApp"];
        [self.config.userContentController removeScriptMessageHandlerForName:@"iosTrade"];
        [self.config.userContentController removeScriptMessageHandlerForName:@"iosCloseWeb"];
        [self.config.userContentController removeScriptMessageHandlerForName:@"jump"];
        [self.config.userContentController removeScriptMessageHandlerForName:@"getUserInfo"];
        [self.config.userContentController removeScriptMessageHandlerForName:@"share"];
        [self.config.userContentController removeScriptMessageHandlerForName:@"handlerHttp"];
        [(WKWebView *)_webview removeObserver:self forKeyPath:@"estimatedProgress" context:nil];
    }
    else
    {
        [(UIWebView *)_webview scrollView].delegate = nil;
    }
}

- (void)setDelegate:(id<UIScrollViewDelegate>)delegate
{
    if (IOS8) {
        [(WKWebView *)_webview scrollView].delegate = delegate;
    }
    else
    {
        [(UIWebView *)_webview scrollView].delegate = delegate;
    }
}

- (void)setNormalColor:(UIColor *)normalColor
{
    self.backgroundColor = normalColor;
    if (IOS8) {
        [(WKWebView *)_webview scrollView].backgroundColor = normalColor;
    }
    else
    {
        [(UIWebView *)_webview scrollView].backgroundColor = normalColor;
    }
}

- (void)setMessageHander:(id<WKScriptMessageHandler>)messageHander
{
    if (IOS8) {
        // 我们可以在WKScriptMessageHandler代理中接收到
        [self.config.userContentController addScriptMessageHandler:messageHander name:@"iosDownApp"];
        [self.config.userContentController addScriptMessageHandler:messageHander name:@"iosTrade"];
        [self.config.userContentController addScriptMessageHandler:messageHander name:@"iosCloseWeb"];
        [self.config.userContentController addScriptMessageHandler:messageHander name:@"jump"];
        [self.config.userContentController addScriptMessageHandler:messageHander name:@"getUserInfo"];
        [self.config.userContentController addScriptMessageHandler:messageHander name:@"share"];
        [self.config.userContentController addScriptMessageHandler:messageHander name:@"handlerHttp"];
    }
    else
    {
        
    }
}

- (UIViewController *)viewController {

    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;  
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *requestString = [[navigationAction.request URL] absoluteString];
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
      
        if (self.images.count > 0) {
            NSString *urlString = [requestString substringFromIndex:[@"myweb:imageClick:" length]];
            if ([self.tempImages containsObject:urlString]) {
                NSInteger index = [self.tempImages indexOfObject:urlString];
                [self.photoBrowser setCurrentPhotoIndex:index];
                [self.viewController presentViewController:self.photoNavigationController animated:YES completion:nil];
            }
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else if ([requestString containsString:@"alipay://"] || [requestString containsString:@"weixin://"]) {
        [[UIApplication sharedApplication] openURL:[navigationAction.request URL]];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)createUI
{
    if (IOS8) {
        self.config = [[WKWebViewConfiguration alloc] init];
        // 设置偏好设置
        self.config.preferences = [[WKPreferences alloc] init];
        // 默认为0
        self.config.preferences.minimumFontSize = 10;
        // 默认认为YES
        self.config.preferences.javaScriptEnabled = YES;
        // 在iOS上默认为NO，表示不能自动通过窗口打开
        self.config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        // 通过JS与webview内容交互
        self.config.userContentController = [[WKUserContentController alloc] init];
        
        WKWebView *webview = [[WKWebView alloc] initWithFrame:self.bounds configuration:self.config];
        [webview setNavigationDelegate:self];
        [webview loadHTMLString:@"<meta name=\"viewport\" content=\"width=device-width\"/>" baseURL:nil];
        webview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
        _webview = webview;
        [self insertSubview:_webview atIndex:0];
        [webview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self addSubview:self.progressView];
    }
    else {
        UIWebView *webview = [[UIWebView alloc] initWithFrame:self.bounds];
        [webview setDelegate:self];
        [webview loadHTMLString:@"<meta name=\"viewport\" content=\"width=device-width\"/>" baseURL:nil];
        webview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
        _webview = webview;
        [self insertSubview:_webview atIndex:0];
        [self addSubview:self.activity];
    }
    
    urlCache = [NSURLCache sharedURLCache];
    /* 设置缓存的大小为1M */
    [urlCache setMemoryCapacity:100*1024*1024];
}

- (void)setUrlString:(NSString *)urlString
{
    _urlString = urlString;
    NSURL *url = [NSURL URLWithString:_urlString];
    
    //创建一个请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0f];
    //从请求中获取缓存输出
    NSCachedURLResponse *response = [urlCache cachedResponseForRequest:request];
    
    //判断是否有缓存
    if (response != nil){
        
        NSLog(@"从缓存中获取数据");
        [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    }
    
    // 3.发送请求
    if (IOS8) {
        [(WKWebView *)self.webview loadRequest:request];
    }
    else  {
        [(UIWebView *)self.webview loadRequest:request];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (_activity.hidden) {
        [_activity setHidden:NO];
        [_activity startAnimating];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!_activity.hidden) {
        [_activity setHidden:YES];
        [_activity stopAnimating];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self getImageUrlByJS:webView];
//    [self cancelSystemMenu:webView];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (object == _webview && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1) {
            [self.progressView setHidden:YES];
            [self.progressView setProgress:0 animated:NO];
        }else {
            [self.progressView setHidden:NO];
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}

- (void)getImageUrlByJS:(WKWebView *)wkWebView
{
    if (_isGETALLPHOTO) {
        
        static NSString *const jsGetImages = @"function getImages(){"
        "var objs = document.getElementsByTagName(\"img\");"
        "var imgUrlStr='';"
        "for(var i=0;i<objs.length;i++){"
        "if(i==0){"
        "if(objs[i].alt!='N'){"
        "imgUrlStr=objs[i].src;"
        "}"
        "}else{"
        "if(objs[i].alt!='N'){"
        "imgUrlStr+='#'+objs[i].src;"
        "}"
        "}"
        "objs[i].onclick=function(){"
        "if(this.alt!='N'){"
        "document.location=\"myweb:imageClick:\"+this.src;"
        "}"
        "};"
        "};"
        "return imgUrlStr;"
        "};";
        
        [wkWebView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
        }];
        
        __weak typeof(self) weakself = self;
        [wkWebView evaluateJavaScript:@"getImages()" completionHandler:^(id Result, NSError * error) {
            NSString *resurlt = [NSString stringWithFormat:@"%@",Result];
            if([resurlt hasPrefix:@"#"])
            {
                resurlt = [resurlt substringFromIndex:1];
            }
            [weakself.images removeAllObjects];
            
            weakself.tempImages = [resurlt componentsSeparatedByString:@"#"];
            for (NSString *str in weakself.tempImages) {
                if (str && ![str isEqualToString:@""]) {
                    [weakself.images addObject:[MWPhoto photoWithURL:[NSURL URLWithString:str]]];
                }
            }
        }];
    }
}

- (void)setJavaScriptString:(NSString *)javaScriptString success:(void (^)(id))success
{
    if (IOS8) {
        [(WKWebView *)self.webview evaluateJavaScript:javaScriptString completionHandler:^(id _Nullable Result, NSError * _Nullable error) {
            if (!Result || [Result isBlankString]) {
                success(nil);
            }
            else
            {
                id source = [Result mj_JSONObject];
                success(source);
            }
        }];
    }
    else {
    }
}

- (void)cancelSystemMenu:(WKWebView *)wkWebView
{
    [wkWebView evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:^(id Result, NSError * _Nullable error) {
        
    }];
    [wkWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id Result, NSError * _Nullable error) {
        
    }];
}

- (NSMutableArray *)images
{
    if (_images == nil) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.images count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.images.count)
    {
        return [self.images objectAtIndex:index];
    }
    return nil;
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    
    return [NSString stringWithFormat:@"%lu/%lu", (unsigned long)index+1, (unsigned long)self.images.count];
}
@end
