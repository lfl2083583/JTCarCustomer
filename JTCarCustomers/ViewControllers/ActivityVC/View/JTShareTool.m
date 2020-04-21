//
//  JTShareTool.m
//  JTCarCustomers
//
//  Created by lious on 2018/4/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#define ShareItemWidth 60
#import "JTShareTool.h"

@implementation JTShareTool

+ (instancetype)instance {
    @synchronized(self)
    {
        static JTShareTool *shareTool = nil;
        if (shareTool == nil)
        {
            shareTool = [[self alloc] init];
        }
        return shareTool;
    }
}

- (void)shareInfo:(NSDictionary *)info result:(void(^)(NSError *error, JTSharePlatformType platformType))block {
    if (!info) {
        return;
    }
    [self setShareContentType:JTShareContentTypeUrl];
    [self setShareDict:info];
    [self setupViews];
    [self isShowAnimate:YES];
    self.callBack = ^(NSError *error, JTSharePlatformType platformType)
    {
        if (block) {
            block(error, platformType);
        }
    };
}

- (void)shareButtonClick:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    [self shareWithType:sender.tag withResult:^(NSError *error, JTSharePlatformType platformType) {
        if (weakself.callBack) {
            weakself.callBack(error, sender.tag);
        }
    }];
    [self isShowAnimate:NO];
}

- (void)cancelBtnClick:(UIButton *)sender {
    [self isShowAnimate:NO];
}

- (void)controlClick:(UIControl *)sender {
    [self isShowAnimate:NO];
}

- (void)shareWithType:(NSInteger)platformType withResult:(void(^)(NSError *error, JTSharePlatformType platformType))block {
    if (platformType < 4) {
        //调用分享接口
        UMSocialPlatformType type = UMSocialPlatformType_WechatSession;
        NSString *content = @"";
        switch (platformType) {
            case 0:
            {
                type = UMSocialPlatformType_WechatSession;
                content = @"你还未安装微信客户端";
            }
                break;
            case 1:
            {
                type = UMSocialPlatformType_QQ;
                content = @"你还未安装QQ客户端";
            }
                break;
            case 2:
            {
                type = UMSocialPlatformType_Qzone;
                content = @"你还未安装QQ空间客户端";
            }
                break;
            case 3:
            {
                type = UMSocialPlatformType_WechatTimeLine;
                content = @"你还未安装微信客户端";
            }
                break;
                
            default:
                break;
        }
        
        BOOL isInstall = [[UMSocialManager defaultManager] isInstall:(type == UMSocialPlatformType_Qzone?UMSocialPlatformType_QQ : type)];
        if (!isInstall ) {
            
            [[HUDTool shareHUDTool] showHint:content yOffset:0];
        }
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        if (self.shareContentType == JTShareContentTypeUrl) {
            
            //创建网页内容对象
            NSString *thumbURL = [self.shareDict objectForKey:ShareThumbURL];
            NSString *title = [self.shareDict objectForKey:ShareTitle];
            NSString *describe = [self.shareDict objectForKey:ShareDescribe];
            NSString *url = [self.shareDict objectForKey:ShareUrl];
            if ([title isBlankString] || [ShareDescribe isBlankString] || [url isBlankString]) {
                return;
            }
            UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:describe thumImage:thumbURL];
            
            //设置网页地址
            shareObject.webpageUrl = url;
            
            //分享消息对象设置分享内容对象
            messageObject.shareObject = shareObject;
            
        }
        else if (self.shareContentType == JTShareContentTypeImage) {
            
            UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
            shareObject.shareImage = self.shareImage;
            messageObject.shareObject = shareObject;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[UMSocialManager defaultManager] shareToPlatform:type messageObject:messageObject currentViewController:[Utility currentViewController] completion:^(id data, NSError *error) {
                if (error) {
                    UMSocialLogInfo(@"************Share fail with error %@*********", error);
                }
                else {
                    if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                        UMSocialShareResponse *resp = data;
                        //分享结果消息
                        UMSocialLogInfo(@"response message is %@",resp.message);
                        //第三方原始返回的数据
                        UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    }
                    else {
                        UMSocialLogInfo(@"response data is %@",data);
                    }
                }
                if (block) {
                    block(error, platformType);
                }
            }];
        });
    }
    else
    {
        if (block) {
            block(nil, platformType);
        }
    }
   
}


- (void)isShowAnimate:(BOOL)isShow
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        if (isShow) {
            weakself.shareView.frame = CGRectMake(0, SC_DEVICE_SIZE.height-HEIGHT(weakself.shareView), SC_DEVICE_SIZE.width, HEIGHT(weakself.shareView));
            weakself.shareControl.backgroundColor = RGBCOLOR(0, 0, 0, 0.6);
        }
        else
        {
            weakself.shareView.frame = CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, HEIGHT(weakself.shareView));
            weakself.shareControl.backgroundColor = RGBCOLOR(0, 0, 0, 0);
        }
        
    } completion:^(BOOL finished) {
        
        if (finished && !isShow) {
            [weakself.shareControl setHidden:YES];
            [weakself.shareView setHidden:YES];
            [weakself.shareControl removeFromSuperview];
            [weakself.shareView removeFromSuperview];
            [weakself setShareControl:nil];
            [weakself setShareView:nil];
        }
    }];
}

- (void)setupViews {
    if (!self.shareControl) {
        [self setShareControl:[[UIControl alloc] init]];
        [self.shareControl setBackgroundColor:RGBCOLOR(0, 0, 0, 0)];
        [self.shareControl setFrame:SC_DEVICE_BOUNDS];
        [self.shareControl addTarget:self action:@selector(controlClick:) forControlEvents:UIControlEventTouchUpInside];
        [[Utility mainWindow] addSubview:self.shareControl];
    }
    else
    {
        [self.shareControl setHidden:NO];
    }
    
    if (!self.shareView) {
        [self setShareView:[self configShareView]];
        [self.shareView setFrame:CGRectMake(0, SC_DEVICE_SIZE.height, SC_DEVICE_SIZE.width, HEIGHT(self.shareView))];
        [[Utility mainWindow] addSubview:self.shareView];
    }
    else
    {
        [self.shareView setHidden:NO];
    }
}

- (UIView *)configShareView {
    NSArray *titleArr = @[ @"微信", @"QQ", @"QQ空间", @"朋友圈",@"溜车群", @"溜车好友"];
    NSArray *imagesArr = @[@"login_weixin", @"login_qq", @"share_zone_icon", @"share_cicle_icon", @"share_group_icon", @"share_friend_icon"];
    CGFloat shareButtonWidth = ShareItemWidth;
    CGFloat shareButtonHeight = shareButtonWidth+20;
    CGFloat xspace = (App_Frame_Width-4*shareButtonWidth)/5.0;
    CGFloat contentViewHeight = shareButtonHeight*2+xspace*3+50;
    UIView *contenView = [[UIView alloc] initWithFrame:CGRectMake(0, SC_DEVICE_SIZE.height-contentViewHeight, SC_DEVICE_SIZE.width, contentViewHeight)];
    contenView.backgroundColor = BlackLeverColor1;
    
    for (int j = 0; j < titleArr.count; j ++) {
        int cloun = j/4;
        int line = j%4;
        UIButton *_shareButton = [[UIButton alloc] initWithFrame:CGRectMake(xspace+(shareButtonWidth+xspace)*line, contentViewHeight-(shareButtonHeight+xspace)*(cloun+1)-50, shareButtonWidth, shareButtonHeight)];
        _shareButton.tag = j;
        _shareButton.titleLabel.font = Font(14);
        _shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_shareButton setImageEdgeInsets:UIEdgeInsetsMake(-25.0, 0.0, 0.0, -_shareButton.titleLabel.bounds.size.width)];
        [_shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_shareButton setImage:[UIImage imageNamed:imagesArr[j]] forState:UIControlStateNormal];
        UILabel *_titleLB = [[UILabel alloc] initWithFrame:CGRectMake(xspace+(shareButtonWidth+xspace)*line, contentViewHeight-(shareButtonHeight+xspace)*(cloun+1)+shareButtonHeight-70, shareButtonWidth, 20)];
        _titleLB.font = Font(14);
        _titleLB.textColor = BlackLeverColor3;
        _titleLB.textAlignment = NSTextAlignmentCenter;
        _titleLB.text = titleArr[j];
        [contenView addSubview:_titleLB];
        [contenView addSubview:_shareButton];
        
    }
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(contenView.frame)-50, SC_DEVICE_SIZE.width, 50)];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:BlackLeverColor3 forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = Font(16);
    cancelBtn.backgroundColor = WhiteColor;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [contenView addSubview:cancelBtn];
    
    return contenView;
}

@end
