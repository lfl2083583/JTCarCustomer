//
//  JTForwardContentView.m
//  JTCarCustomers
//
//  Created by lious on 2018/5/9.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#define MaxContentHeight 180
#import "JTForwardContentView.h"
#import "JTImageAttachment.h"
#import "JTExpressionAttachment.h"
#import "JTCardAttachment.h"
#import "JTVideoAttachment.h"
#import "JTGroupAttachment.h"
#import "JTActivityAttachment.h"
#import "JTInformationAttachment.h"
#import "JTShopAttachment.h"

@implementation JTForwardContentView

- (instancetype)initWithSource:(id)source {
    self = [super init];
    if (self) {
        _source = source;
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
}

- (CGSize)contentSize:(CGSize)originalSize
{
    if (originalSize.width && originalSize.height) {
        CGFloat attachmentImageMinWidth  = 40.0;
        CGFloat attachmentImageMinHeight = 40.0;
        CGFloat attachmemtImageMaxWidth  = 150.0*[UIScreen mainScreen].bounds.size.width/375.0;
        CGFloat attachmentImageMaxHeight = 150.0*[UIScreen mainScreen].bounds.size.width/375;
        CGSize imageSize = originalSize;
        CGSize turnImageSize = [UIImage jt_sizeWithImageOriginSize:imageSize
                                                           minSize:CGSizeMake(attachmentImageMinWidth, attachmentImageMinHeight)
                                                           maxSize:CGSizeMake(attachmemtImageMaxWidth, attachmentImageMaxHeight)];
        return CGSizeMake(turnImageSize.width+4.0, turnImageSize.height+4.0);
    }
    else
    {
        return CGSizeMake(80.0, 80.0);
    }
}

- (FLAnimatedImageView *)imageView {
    if (!_imageView) {
        _imageView = [[FLAnimatedImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 2;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
    }
    return _titleLB;
}

- (UILabel *)detailLB {
    if (!_detailLB) {
        _detailLB = [[UILabel alloc] init];
    }
    return _detailLB;
}
@end


@implementation JTForwardTextView

- (void)setupView {
    [super setupView];
    self.detailLB.font = Font(16);
    self.detailLB.numberOfLines = 7;
    [self addSubview:self.detailLB];
    
    if (self.source && [self.source isKindOfClass:[NIMMessage class]]) {
        NIMMessage *message = self.source;
        CGSize size = [Utility getTextString:message.text textFont:Font(16) frameWidth:Popup_Width-50.0 attributedString:nil];
        [self.detailLB setFrame:CGRectMake(X_Margin, Y_Margin, Popup_Width-50.0, MIN(size.height, MaxContentHeight-Y_Margin))];
        [self setFrame:CGRectMake(0, 0, Popup_Width, CGRectGetHeight(self.detailLB.frame)+Y_Margin)];
        
        [self.detailLB setText:message.text];
    }
}


@end

@implementation JTForwardImgeView

- (void)setupView {
    [super setupView];
    [self addSubview:self.imageView];
    if (self.source && [self.source isKindOfClass:[NIMMessage class]]) {
        NIMMessage *message = self.source;
        CGSize size;
        NSString *urlStr;
        if ([message.messageObject isKindOfClass:[NIMImageObject class]]) {
            NIMImageObject *object = (NIMImageObject *)message.messageObject;
            size = [self contentSize:CGSizeMake(object.size.width, object.size.height)];
            urlStr = object.thumbUrl;
            
        }
        else if ([message.messageObject isKindOfClass:[NIMCustomObject class]])
        {
            NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
            JTImageAttachment *attachment = (JTImageAttachment *)object.attachment;
            size = [self contentSize:CGSizeMake([attachment.imageWidth floatValue], [attachment.imageHeight floatValue])];
            urlStr = attachment.imageUrl;
        }
        
        [self.imageView setFrame:CGRectMake((Popup_Width-size.width)/2.0, Y_Margin, size.width, size.height)];
        [self setFrame:CGRectMake(0, 0, Popup_Width, size.height+Y_Margin)];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[urlStr avatarHandleWithSize:CGSizeMake(size.width*2, size.height*2)]]];
        
    }
}


@end

@implementation JTForwardVideoView

- (void)setupView {
    [super setupView];
    [self addSubview:self.imageView];
    [self addSubview:self.playImgeView];
    
    if (self.source && [self.source isKindOfClass:[NIMMessage class]]) {
        NIMMessage *message = self.source;
        CGSize size;
        NSString *urlStr;
        if ([message.messageObject isKindOfClass:[NIMVideoObject class]]) {
            NIMVideoObject *object = (NIMVideoObject *)message.messageObject;
            size = [self contentSize:CGSizeMake(object.coverSize.width, object.coverSize.height)];
            urlStr = object.coverUrl;
        }
        else if ([message.messageObject isKindOfClass:[NIMCustomObject class]])
        {
            NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
            JTVideoAttachment *attachment = (JTVideoAttachment *)object.attachment;
            size = [self contentSize:CGSizeMake([attachment.videoWidth floatValue], [attachment.videoHeight floatValue])];
            urlStr = attachment.videoCoverUrl;
        }
        
        [self.imageView setFrame:CGRectMake((Popup_Width-size.width)/2.0, Y_Margin, size.width, size.height)];
        [self.playImgeView setCenter:self.imageView.center];
        [self setFrame:CGRectMake(0, 0, Popup_Width, size.height+Y_Margin)];
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
}

- (UIImageView *)playImgeView {
    if (!_playImgeView) {
        _playImgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
        _playImgeView.image = [UIImage imageNamed:@"bt_play"];
    }
    return _playImgeView;
}

@end

@implementation JTForwardLoctionView

- (void)setupView {
    [super setupView];
    self.detailLB.font = Font(16);
    [self addSubview:self.imageView];
    [self addSubview:self.detailLB];
    
    if (self.source && [self.source isKindOfClass:[NIMMessage class]]) {
        
        NIMMessage *message = self.source;
        NIMLocationObject *object = (NIMLocationObject *)message.messageObject;
        
        [self.imageView setFrame:CGRectMake(X_Margin, Y_Margin, 50.0, 50.0)];
        [self.detailLB setFrame:CGRectMake(CGRectGetMaxX(self.imageView.frame)+10.0, Y_Margin, Popup_Width-X_Margin*2-60.0, 20.0)];
        [self.detailLB setCenterY:self.imageView.centerY];
        [self setFrame:CGRectMake(0, 0, Popup_Width, 50.0+Y_Margin)];
        
        [self.imageView setImage:[UIImage imageNamed:@"icon_location"]];
        [self.detailLB setText:object.title];
        NSArray *array = [object.title componentsSeparatedByString:@"&&&&&&"];
        [self.detailLB setText:array[0]];
    }
}

@end


@implementation JTForwardExpressionView

- (void)setupView {
    [super setupView];
    self.detailLB.font = Font(16);
    [self addSubview:self.imageView];
    
    if (self.source && [self.source isKindOfClass:[NIMMessage class]]) {
        
        NIMMessage *message = self.source;
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        JTExpressionAttachment *attachment = (JTExpressionAttachment *)object.attachment;
        CGSize size = [self contentSize:CGSizeMake([attachment.expressionWidth floatValue], [attachment.expressionHeight floatValue])];
        BOOL isGif = [[attachment expressionUrl] hasSuffix:@"gif"];
        NSURL *url;
        if (isGif) {
            url = [NSURL URLWithString:[(JTExpressionAttachment *)attachment expressionUrl]];
        }
        else
        {
            url = [NSURL URLWithString:[[attachment expressionUrl] avatarHandleWithSize:CGSizeMake(size.width*2, size.height*2)]];
        }
        
        [self.imageView setFrame:CGRectMake((Popup_Width-size.width)/2.0, Y_Margin, size.width, size.height)];
        [self setFrame:CGRectMake(0, 0, Popup_Width, size.height+Y_Margin)];
        
        [self.imageView sd_setImageWithURL:url];
    }
}

@end

@implementation JTForwardUserCardView

- (void)setupView {
    [super setupView];
    self.titleLB.font = Font(16);
    self.titleLB.textColor = BlackLeverColor3;
    self.titleLB.text = @"【个人名片】";
    self.detailLB.font = Font(16);
    self.detailLB.textColor = BlackLeverColor6;
    
    [self addSubview:self.titleLB];
    [self addSubview:self.detailLB];
    
    [self.titleLB setFrame:CGRectMake(X_Margin, Y_Margin, 100.0, 20.0)];
    [self.detailLB setFrame:CGRectMake(CGRectGetMaxX(self.titleLB.frame), Y_Margin, Popup_Width-X_Margin-115.0, 20.0)];
    [self setFrame:CGRectMake(0, 0, Popup_Width, 20.0+Y_Margin)];
    
    if (self.source && [self.source isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dictionary = self.source;
        [self.detailLB setText:[dictionary objectForKey:@"name"]];
    }
    else if (self.source && [self.source isKindOfClass:[NIMMessage class]])
    {
        NIMMessage *message = self.source;
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        if ([object.attachment isKindOfClass:[JTCardAttachment class]]) {
            JTCardAttachment *attachment = (JTCardAttachment *)object.attachment;
            [self.detailLB setText:attachment.userName];
        }
    }
}

@end

@implementation JTForwardTeamCardView

- (void)setupView {
    [super setupView];
    self.titleLB.font = Font(16);
    self.titleLB.textColor = BlackLeverColor3;
    self.titleLB.text = @"【群名片】";
    self.detailLB.font = Font(16);
    self.detailLB.textColor = BlackLeverColor6;
    
    [self addSubview:self.titleLB];
    [self addSubview:self.detailLB];
    
    [self.titleLB setFrame:CGRectMake(X_Margin, Y_Margin, 100.0, 20.0)];
    [self.detailLB setFrame:CGRectMake(CGRectGetMaxX(self.titleLB.frame), Y_Margin, Popup_Width-X_Margin-115.0, 20.0)];
    [self setFrame:CGRectMake(0, 0, Popup_Width, 20.0+Y_Margin)];
    
    if (self.source && [self.source isKindOfClass:[NIMMessage class]]) {
        
        NIMMessage *message = self.source;
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        JTGroupAttachment *attachment = (JTGroupAttachment *)object.attachment;
        [self.detailLB setText:attachment.name];
    }
}

@end


@implementation JTForwardActivityView

- (void)setupView {
    [super setupView];
    self.titleLB.font = Font(18);
    self.titleLB.textColor = BlackLeverColor6;
    self.themeLB = [[UILabel alloc] init];
    self.themeLB.font = Font(14);
    self.themeLB.textColor = BlackLeverColor3;
    self.timeLB = [[UILabel alloc] init];
    self.timeLB.font = Font(14);
    self.timeLB.textColor = BlackLeverColor3;
    self.siteLB = [[UILabel alloc] init];
    self.siteLB.font = Font(14);
    self.siteLB.textColor = BlackLeverColor3;
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLB];
    [self addSubview:self.themeLB];
    [self addSubview:self.timeLB];
    [self addSubview:self.siteLB];
    
    [self.imageView setFrame:CGRectMake(X_Margin, Y_Margin, 80.0, 105.0)];
    [self.titleLB setFrame:CGRectMake(X_Margin+90.0, Y_Margin+5.0, Popup_Width-X_Margin-100.0, 20)];
    [self.themeLB setFrame:CGRectMake(X_Margin+90.0, CGRectGetMaxY(self.titleLB.frame)+15.0, Popup_Width-X_Margin-100.0, 20)];
    [self.timeLB setFrame:CGRectMake(X_Margin+90.0, CGRectGetMaxY(self.themeLB.frame), Popup_Width-X_Margin-100.0, 20)];
    [self.siteLB setFrame:CGRectMake(X_Margin+90.0, CGRectGetMaxY(self.timeLB.frame), Popup_Width-X_Margin-100.0, 20)];
    [self setFrame:CGRectMake(0, 0, Popup_Width, 105.0+Y_Margin)];
    
    if (self.source && [self.source isKindOfClass:[NSDictionary class]]) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.source[@"image"] avatarHandleWithSize:self.imageView.size]]];
        [self.titleLB setText: @"邀请你参加活动"];
        [self.themeLB setText:[NSString stringWithFormat:@"主题：%@", self.source[@"theme"]]];
        [self.timeLB setText:[NSString stringWithFormat:@"时间：%@", self.source[@"time"]]];
        [self.siteLB setText:[NSString stringWithFormat:@"地点：%@", self.source[@"address"]]];
    }
    else if (self.source && [self.source isKindOfClass:[NIMMessage class]])
    {
        NIMMessage *message = self.source;
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        JTActivityAttachment *attachment = (JTActivityAttachment *)object.attachment;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[attachment.coverUrl avatarHandleWithSize:self.imageView.size]]];
        [self.titleLB setText:@"邀请你参加活动"];
        [self.themeLB setText:[NSString stringWithFormat:@"主题：%@", attachment.theme]];
        [self.timeLB setText:[NSString stringWithFormat:@"时间：%@", attachment.time]];
        [self.siteLB setText:[NSString stringWithFormat:@"地点：%@", attachment.address]];
    }
}

@end

@implementation JTForwardStoreView

- (void)setupView {
    [super setupView];
    
    self.titleLB.font = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
    self.titleLB.textColor = BlackLeverColor6;
    self.detailLB.font = Font(10);
    self.detailLB.textColor = BlackLeverColor3;
    self.siteLB = [[UILabel alloc] init];
    self.siteLB.font = Font(12);
    self.siteLB.textColor = BlackLeverColor3;
    self.scoreLB = [[UILabel alloc] init];
    self.scoreLB.font = Font(12);
    self.scoreLB.textColor = BlackLeverColor3;
    
    [self.imageView setFrame:CGRectMake(X_Margin, Y_Margin, 80.0, 80.0)];
    [self.titleLB setFrame:CGRectMake(X_Margin+90.0, Y_Margin+5, Popup_Width-X_Margin-100.0, 20)];
    self.starView = [[ZTStarView alloc] initWithFrame:CGRectMake(X_Margin+90.0, CGRectGetMaxY(self.titleLB.frame)+5, 50, 12) numberOfStar:5];
    [self.starView setUserInteractionEnabled:NO];
    [self.scoreLB setFrame:CGRectMake(CGRectGetMaxX(self.starView.frame)+5, CGRectGetMaxY(self.titleLB.frame)+5, 40, 18)];
    [self.scoreLB setCenterY:self.starView.centerY];
    [self.detailLB setFrame:CGRectMake(X_Margin+90.0, CGRectGetMaxY(self.starView.frame), Popup_Width-X_Margin-100.0, 14)];
    [self.siteLB setFrame:CGRectMake(X_Margin+90.0, CGRectGetMaxY(self.detailLB.frame)+3, Popup_Width-X_Margin-100.0, 20)];
    [self setFrame:CGRectMake(0, 0, Popup_Width, 80+Y_Margin)];
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLB];
    [self addSubview:self.detailLB];
    [self addSubview:self.starView];
    [self addSubview:self.siteLB];
    [self addSubview:self.scoreLB];
    
    if (self.source && [self.source isKindOfClass:[NSDictionary class]])
    {

    }
    else if (self.source && [self.source isKindOfClass:[NIMMessage class]])
    {
        NIMMessage *message = self.source;
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        JTShopAttachment *attachment = (JTShopAttachment *)object.attachment;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[attachment.coverUrl avatarHandleWithSquare:160]]];
        [self.titleLB setText:attachment.name];
        [self.starView setScore:[attachment.score floatValue]/5.0 withAnimation:YES];
        [self.detailLB setText:[NSString stringWithFormat:@"营业时间：%@", attachment.time]];
        [self.siteLB setText:attachment.address];
        [self.scoreLB setText:attachment.score];
    }
    
}

@end

@implementation JTForwardInfomationView

- (void)setupView {
    [super setupView];
    self.titleLB.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.titleLB.textColor = BlackLeverColor6;
    self.detailLB.font = Font(14);
    self.detailLB.numberOfLines = 2;
    self.detailLB.textColor = BlackLeverColor3;
    [self addSubview:self.imageView];
    [self addSubview:self.titleLB];
    [self addSubview:self.detailLB];
    
    [self.imageView setFrame:CGRectMake(X_Margin, Y_Margin, 80.0, 80.0)];
    [self.titleLB setFrame:CGRectMake(X_Margin+90.0, Y_Margin+8, Popup_Width-X_Margin-100.0, 20)];
    [self.detailLB setFrame:CGRectMake(X_Margin+90.0, CGRectGetMaxY(self.titleLB.frame)+5, Popup_Width-X_Margin-100.0, 40)];
    [self setFrame:CGRectMake(0, 0, Popup_Width, 80+Y_Margin)];
    
    if (self.source && [self.source isKindOfClass:[NSDictionary class]])
    {
        [self.titleLB setText:self.source[@"title"]];
        [self.detailLB setText:self.source[@"subTitle"]];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[self.source[@"img"] avatarHandleWithSquare:160]]];
    }
    else if (self.source && [self.source isKindOfClass:[NIMMessage class]])
    {
        NIMMessage *message = self.source;
        NIMCustomObject *object = (NIMCustomObject *)message.messageObject;
        JTInformationAttachment *attachment = (JTInformationAttachment *)object.attachment;
        [self.titleLB setText:attachment.title];
        [self.detailLB setText:attachment.content];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:[attachment.coverUrl avatarHandleWithSquare:160]]];
    }
}


@end
