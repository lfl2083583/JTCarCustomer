//
//  JTMyLoveCarHeaderView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/2.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTMyLoveCarHeaderView.h"
#import "iCarousel.h"
#import "JTCarItemView.h"
#import "JTAddCarViewController.h"
#import "JTCarCertificationRewardViewController.h"

@interface JTMyLoveCarHeaderView () <iCarouselDelegate, iCarouselDataSource, JTCarItemViewDelegate>

@property (strong, nonatomic) iCarousel *carousel;
@property (copy, nonatomic) NSArray *dataArray;

@end

@implementation JTMyLoveCarHeaderView

- (instancetype)initWithMyDelegate:(id<JTMyLoveCarHeaderViewDelegate>)delegate
{
    self = [super init];
    if (self) {
        [self setDelegate:delegate];
        [self setFrame:CGRectMake(0, 0, App_Frame_Width, 260)];
        [self initSubview];
    }
    return self;
}

- (void)reloadData:(NSArray *)dataArray scrollToIndex:(NSInteger)index
{
    [self setDataArray:dataArray];
    [self.carousel reloadData];
    [self.carousel setCurrentItemIndex:index];
}

- (void)drawRect:(CGRect)rect {
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer.colors = @[(__bridge id)BlueLeverColor2.CGColor, (__bridge id)BlueLeverColor1.CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return MAX(self.dataArray.count, 1);
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    if (view == nil) {
        view = [[JTCarItemView alloc] initWithFrame:CGRectMake(0, 20, 264*App_Frame_Width/375, 130) delegate:self];
        view.contentMode = UIViewContentModeCenter;
    }
    if (self.dataArray.count == 0) {
        [(JTCarItemView *)view setIsHideSubView:YES];
    }
    else
    {
        [(JTCarItemView *)view setModel:[self.dataArray objectAtIndex:index]];
        [(JTCarItemView *)view setIsHideSubView:NO];
    }
    return view;
}

- (void)carouselDidScroll:(iCarousel *)carousel;
{
    if (_delegate && [_delegate respondsToSelector:@selector(myLoveCarHeaderView:didScrollToIndex:)]) {
        [_delegate myLoveCarHeaderView:self didScrollToIndex:carousel.currentItemIndex];
    }
}

- (void)carItemView:(JTCarItemView *)carItemView carOperationType:(JTCarOperationType)carOperationType
{
    if (carOperationType == JTCarOperationTypeAdd) {
        [[Utility currentViewController].navigationController pushViewController:[[JTAddCarViewController alloc] init] animated:YES];
    }
    else if (carOperationType == JTCarOperationTypeDefault) {
        __weak typeof(self) weakself = self;
        [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(setCarApi) parameters:@{@"car_id": carItemView.model.carID} success:^(id responseObject, ResponseState state) {
            [[JTUserInfo shareUserInfo] resetDefaultCarModel:carItemView.model];
            [[JTUserInfo shareUserInfo] save];
            for (JTCarModel *model in weakself.dataArray) {
                model.isDefault = [model.carID isEqualToString:carItemView.model.carID];
            }
            [weakself.carousel reloadData];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMyCarListNotification object:nil];
        } failure:^(NSError *error) {
        }];
    }
    else if (carOperationType == JTCarOperationTypeAuth) {
        [[Utility currentViewController].navigationController pushViewController:[[JTCarCertificationRewardViewController alloc] initCarModel:carItemView.model] animated:YES];
    }
}

- (iCarousel *)carousel
{
    if (!_carousel) {
        _carousel = [[iCarousel alloc] init];
        _carousel.frame = CGRectMake(0, 64, self.width, 170);
        _carousel.delegate = self;
        _carousel.dataSource = self;
        _carousel.type = iCarouselTypeLinear;
        _carousel.pagingEnabled = YES;
        _carousel.bounces = NO;
    }
    return _carousel;
}

- (CGFloat)carousel:(__unused iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
//    iCarouselOptionFadeMinAlpha
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            return value * 1.1;
        }
        default:
        {
            return value;
        }
            break;
    }
}

- (void)initSubview
{
    [self addSubview:self.carousel];
}

@end
