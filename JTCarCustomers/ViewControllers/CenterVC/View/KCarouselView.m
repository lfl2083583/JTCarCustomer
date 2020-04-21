//
//  KCarouselView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "KCarouselView.h"
#import "UIImageView+WebCache.h" // 如果这里报错，说明没有导入SDWebImage

#define  kWidth  self.bounds.size.width
#define  kHeight self.bounds.size.height

#define kPageControlMargin 10.0f

typedef NS_ENUM(NSInteger, KCarouseImagesDataStyle){
    KCarouseImagesDataInLocal,// 本地图片标记
    KCarouseImagesDataInURL   // URL图片标记
};

@interface KCarouselView () <UIScrollViewDelegate>

@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIPageControl *pageControl;

// 前一个视图,当前视图,下一个视图
@property(strong, nonatomic) UIImageView *lastImgView;
@property(strong, nonatomic) UIImageView *currentImgView;
@property(strong, nonatomic) UIImageView *nextImgView;

// 图片来源(本地或URL)
@property(nonatomic) KCarouseImagesDataStyle carouseImagesStyle;

// kImageCount = array.count,图片数组个数
@property(assign, nonatomic) NSInteger kImageCount;

// 记录nextImageView的下标 默认从1开始
@property(assign, nonatomic) NSInteger nextPhotoIndex;
// 记录lastImageView的下标 默认从 _kImageCount - 1 开始
@property(assign, nonatomic) NSInteger lastPhotoIndex;

//pageControl图片大小
@property (nonatomic, assign) CGSize pageImageSize;

@end

@implementation KCarouselView

#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _pageColor = [UIColor grayColor];
    _currentPageColor = [UIColor whiteColor];
}

#pragma mark - Public Method
// 如果是本地图片调用此方法
+ (KCarouselView *)carouselScrollViewWithFrame:(CGRect)frame localImages:(NSArray<NSString *> *)localImages{
    KCarouselView *carouseScroll =[[KCarouselView alloc] initWithFrame:frame];
    // 调用set方法
    carouseScroll.localImages = localImages;
    return carouseScroll;
}

// 如果是网络图片调用此方法
+ (KCarouselView *)carouselScrollViewWithFrame:(CGRect)frame urlImages:(NSArray<NSString *> *)urlImages{
    KCarouselView *carouseScroll = [[KCarouselView alloc] initWithFrame:frame];
    // 调用set方法
    carouseScroll.urlImages = urlImages;
    return carouseScroll;
}


#pragma maek - Private Method

-(void)configure{
    [self addSubview:self.scrollView];
    // 添加最初的三张imageView
    [self.scrollView addSubview:self.lastImgView];
    [self.scrollView addSubview:self.currentImgView];
    [self.scrollView addSubview:self.nextImgView];
    [self addSubview:self.pageControl];
    
    // 将上一张图片设置为数组中最后一张图片
    [self setImageView:_lastImgView withSubscript:(_kImageCount-1)];
    // 将当前图片设置为数组中第一张图片
    [self setImageView:_currentImgView withSubscript:0];
    // 将下一张图片设置为数组中第二张图片,如果数组只有一张图片，则上、中、下图片全部是数组中的第一张图片
    [self setImageView:_nextImgView withSubscript:_kImageCount == 1 ? 0 : 1];
    
    _scrollView.contentSize = CGSizeMake(kWidth * 3, kHeight);
    //显示中间的图片
    _scrollView.contentOffset = CGPointMake(kWidth, 0);
    
    if (!_pageControl.hidden) {
        _pageControl.numberOfPages = self.kImageCount;
    }
    _pageControl.currentPage = 0;
    
    self.nextPhotoIndex = 1;
    self.lastPhotoIndex = _kImageCount - 1;
    
    [self layoutIfNeeded];
}

//根据下标设置imgView的image
-(void)setImageView:(UIImageView *)imgView withSubscript:(NSInteger)subcript{
    if (self.carouseImagesStyle == KCarouseImagesDataInLocal) {
        imgView.image = [UIImage imageNamed:self.localImages[subcript]];
    } else{
        //网络图片设置, 如果要使用占位图请自行修改
        [imgView sd_setImageWithURL:[NSURL URLWithString:[self.urlImages[subcript] avatarHandleWithSize:CGSizeMake(self.width*2, self.height*2)]] placeholderImage:nil];
        CCLOG(@"%@",[self.urlImages[subcript] avatarHandleWithSize:CGSizeMake(self.width*2, self.height*2)]);
    }
}

#pragma mark - setter
// 本地图片
- (void)setLocalImages:(NSArray<NSString *> *)localImages {
    if (localImages.count == 0) return;
    if (![_localImages isEqualToArray:localImages]) {
        _localImages = nil;
        _localImages = [localImages copy];
        //标记图片来源
        self.carouseImagesStyle = KCarouseImagesDataInLocal;
        //获取数组个数
        self.kImageCount = _localImages.count;
        [self configure];
    }
}

// 网络图片
- (void)setUrlImages:(NSArray<NSString *> *)urlImages {
    if (urlImages.count == 0) return;
    if (![_urlImages isEqualToArray:urlImages]) {
        _urlImages = nil;
        _urlImages = [urlImages copy];
        //标记图片来源
        self.carouseImagesStyle = KCarouseImagesDataInURL;
        self.kImageCount = _urlImages.count;
        [self configure];
        self.scrollView.scrollEnabled = urlImages.count>1?YES:NO;
    }
}

// 设置其他小圆点的颜色
- (void)setPageColor:(UIColor *)pageColor {
    _pageColor = pageColor;
    _pageControl.pageIndicatorTintColor = pageColor;
}

// 设置当前小圆点的颜色
- (void)setCurrentPageColor:(UIColor *)currentPageColor {
    _currentPageColor = currentPageColor;
    _pageControl.currentPageIndicatorTintColor = currentPageColor;
}

// 是否显示pageControl
- (void)setShowPageControl:(BOOL)showPageControl {
    _showPageControl = showPageControl;
    self.pageControl.hidden = !_showPageControl;
}

// 设置pageControl的位置
- (void)setPageControlPosition:(KPageContolPosition)pageControlPosition {
    _pageControlPosition = pageControlPosition;
    
    if (_pageControl.hidden) return;
    
    CGSize size;
    if (!_pageImageSize.width) {// 没有设置图片，系统原有样式
        size = [_pageControl sizeForNumberOfPages:_pageControl.numberOfPages];
        size.height = 8;
    } else { // 设置图片了
        size = CGSizeMake(_pageImageSize.width * (_pageControl.numberOfPages * 2 - 1), _pageImageSize.height);
    }
    
    _pageControl.frame = CGRectMake(0, 0, size.width, size.height);
    
    CGFloat centerY = kHeight - size.height * 0.5 - kPageControlMargin;
    CGFloat pointY = kHeight - size.height - kPageControlMargin;
    
    switch (pageControlPosition) {
        case KPageContolPositionBottomCenter:
            // 底部中间
            _pageControl.center = CGPointMake(kWidth * 0.5, centerY);
            break;
        case KPageContolPositionBottomRight:
            // 底部右边
            _pageControl.frame = CGRectMake(kWidth - size.width - kPageControlMargin, pointY, size.width, size.height);
            break;
        case KPageContolPositionBottomLeft:
            // 底部左边
            _pageControl.frame = CGRectMake(kPageControlMargin, pointY, size.width, size.height);
            break;
        default:
            break;
    }
}

// 设置imageView的内容模式
- (void)setImageMode:(KCarouselViewImageMode)imageMode {
    _imageMode = imageMode;
    
    switch (imageMode) {
        case KCarouselViewImageModeScaleToFill:
            self.nextImgView.contentMode = self.currentImgView.contentMode = self.lastImgView.contentMode = UIViewContentModeScaleToFill;
            break;
        case KCarouselViewImageModeScaleAKectFit:
            self.nextImgView.contentMode = self.currentImgView.contentMode = self.lastImgView.contentMode = UIViewContentModeScaleAspectFit;
            break;
        case KCarouselViewImageModeScaleAKectFill:
            self.nextImgView.contentMode = self.currentImgView.contentMode = self.lastImgView.contentMode = UIViewContentModeScaleAspectFill;
            break;
        case KCarouselViewImageModeCenter:
            self.nextImgView.contentMode = self.currentImgView.contentMode = self.lastImgView.contentMode = UIViewContentModeCenter;
            break;
        default:
            break;
    }
}

// 设置pageControl的小圆点图片
- (void)setPageImage:(UIImage *)image currentPageImage:(UIImage *)currentImage {
    if (!image || !currentImage) return;
    self.pageImageSize = image.size;
    [self.pageControl setValue:currentImage forKey:@"_currentPageImage"];
    [self.pageControl setValue:image forKey:@"_pageImage"];
}

#pragma mark - scrollView代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    // 到第一张图片时   (一上来，当前图片的x值是kWidth)
    if (ceil(scrollView.contentOffset.x) <= 0) {  // 右滑
        _nextImgView.image = _currentImgView.image;
        _currentImgView.image = _lastImgView.image;
        // 将轮播图的偏移量设回中间位置
        scrollView.contentOffset = CGPointMake(kWidth, 0);
        _lastImgView.image = nil;
        // 一定要是小于等于，否则数组中只有一张图片时会出错
        if (_lastPhotoIndex <= 0) {
            _lastPhotoIndex = _kImageCount - 1;
            _nextPhotoIndex = _lastPhotoIndex - (_kImageCount - 2);
        } else {
            _lastPhotoIndex--;
            if (_nextPhotoIndex == 0) {
                _nextPhotoIndex = _kImageCount - 1;
            } else {
                _nextPhotoIndex--;
            }
        }
        [self setImageView:_lastImgView withSubscript:_lastPhotoIndex];
    }
    // 到最后一张图片时（最后一张就是轮播图的第三张）
    if (ceil(scrollView.contentOffset.x)  >= kWidth*2) {  // 左滑
        _lastImgView.image = _currentImgView.image;
        _currentImgView.image = _nextImgView.image;
        // 将轮播图的偏移量设回中间位置
        scrollView.contentOffset = CGPointMake(kWidth, 0);
        _nextImgView.image = nil;
        // 一定要是大于等于，否则数组中只有一张图片时会出错
        if (_nextPhotoIndex >= _kImageCount - 1 ) {
            _nextPhotoIndex = 0;
            _lastPhotoIndex = _nextPhotoIndex + (_kImageCount - 2);
        } else{
            _nextPhotoIndex++;
            if (_lastPhotoIndex == _kImageCount - 1) {
                _lastPhotoIndex = 0;
            } else {
                _lastPhotoIndex++;
            }
        }
        [self setImageView:_nextImgView withSubscript:_nextPhotoIndex];
    }
    
    if (_nextPhotoIndex - 1 < 0) {
        self.pageControl.currentPage = _kImageCount - 1;
    } else {
        self.pageControl.currentPage = _nextPhotoIndex - 1;
    }
}



#pragma mark - 手势点击事件
-(void)handleTapActionInImageView:(UITapGestureRecognizer *)tap {
    if (self.clickedImageBlock) {
        // 如果_nextPhotoIndex == 0,那么中间那张图片一定是数组中最后一张，我们要传的就是中间那张图片在数组中的下标
        if (_nextPhotoIndex == 0) {
            self.clickedImageBlock(_kImageCount-1);
        }else{
            self.clickedImageBlock(_nextPhotoIndex-1);
        }
    } else if (_delegate && [_delegate respondsToSelector:@selector(carouselView:clickedImageAtIndex:)]) {
        // 如果_nextPhotoIndex == 0,那么中间那张图片一定是数组中最后一张，我们要传的就是中间那张图片在数组中的下标
        if (_nextPhotoIndex == 0) {
            [_delegate carouselView:self clickedImageAtIndex:_kImageCount-1];
        }else{
            [_delegate carouselView:self clickedImageAtIndex:_nextPhotoIndex-1];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.scrollView.frame = self.bounds;
    // 重新设置contentOffset和contentSize对于轮播图下拉放大以及里面的图片跟随放大起着关键作用，因为scrollView放大了，如果不手动设置contentOffset和contentSize，则会导致scrollView的容量不够大，从而导致图片越出scrollview边界的问题
    self.scrollView.contentSize = CGSizeMake(kWidth * 3, kHeight);
    // 这里如果采用动画效果设置偏移量将不起任何作用
    self.scrollView.contentOffset = CGPointMake(kWidth, 0);
    
    self.lastImgView.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.currentImgView.frame = CGRectMake(kWidth, 0, kWidth, kHeight);
    self.nextImgView.frame = CGRectMake(kWidth * 2, 0, kWidth, kHeight);
    
    // 等号左边是掉setter方法，右边调用getter方法
    self.pageControlPosition = self.pageControlPosition;
    
    //NSLog(@"--- %@",NSStringFromCGRect(self.scrollView.frame));
    
}

#pragma mark - 懒加载
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = YES;
        _scrollView.layer.masksToBounds = YES;
    }
    return _scrollView;
}

-(UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = self.pageColor;
        _pageControl.currentPageIndicatorTintColor = self.currentPageColor;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
}

-(UIImageView *)lastImgView{
    if (_lastImgView == nil) {
        _lastImgView = [[UIImageView alloc] init];
        _lastImgView.backgroundColor = [UIColor grayColor];
        _lastImgView.layer.masksToBounds = YES;
    }
    return _lastImgView;
}

-(UIImageView *)currentImgView{
    if (_currentImgView == nil) {
        _currentImgView = [[UIImageView alloc] init];
        _currentImgView.backgroundColor = [UIColor grayColor];
        _currentImgView.layer.masksToBounds = YES;
    }
    return _currentImgView;
}

-(UIImageView *)nextImgView{
    if (_nextImgView == nil) {
        _nextImgView = [[UIImageView alloc] init];
        _nextImgView.layer.masksToBounds = YES;
        _nextImgView.backgroundColor = [UIColor grayColor];
    }
    return _nextImgView;
}

#pragma mark - 系统方法
-(void)willMoveToSuperview:(UIView *)newSuperview {
    
}

-(void)dealloc {
    NSLog(@"dealloc");
    _scrollView.delegate = nil;
}

@end

