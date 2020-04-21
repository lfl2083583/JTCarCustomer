//
//  FJSlidingController.m
//  FJSlidingController
//
//  Created by fujin on 15/12/17.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import "FJSlidingController.h"

@interface FJSlidingController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) NSInteger willIndex;

@end

@implementation FJSlidingController

- (NSMutableArray *)viewControllers {
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self instance];
}

- (void)instance {
    self.currentIndex = 0;
    if (!IOS11) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageController.view.frame = CGRectMake(0, kStatusBarHeight+kTopBarHeight, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-kStatusBarHeight-kTopBarHeight);
    self.pageController.delegate   = self;
    [self.view addSubview:self.pageController.view];
}

- (void)reloadData{
    if (self.isDisableScroll) {
        for (id subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *)subview setScrollEnabled:NO];
            }
        }
    }
    [self.viewControllers removeAllObjects];
    NSInteger num = 0;
    if ([self.datasouce respondsToSelector:@selector(numberOfPageInFJSlidingController:)]) {
        num = [self.datasouce numberOfPageInFJSlidingController:self];
    }
    for (NSInteger i = 0 ; i < num; i++) {
        if ([self.datasouce respondsToSelector:@selector(fjSlidingController:controllerAtIndex:)]) {
            UIViewController *vc = [self.datasouce fjSlidingController:self controllerAtIndex:i];
            [self.viewControllers addObject:vc];
        }
    }
    [self.pageController setViewControllers:@[self.viewControllers[0]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
}

- (NSInteger)indexOfViewController:(UIViewController *)viewController{
    return [self.viewControllers indexOfObject:viewController];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    index --;

    return self.viewControllers[index];
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound || index == self.viewControllers.count - 1) {
        return nil;
    }
    index++;
    
    return self.viewControllers[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    NSInteger index = [self indexOfViewController:pendingViewControllers[0]];
    self.willIndex = index;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if(completed){
        NSInteger index = [self indexOfViewController:previousViewControllers[0]];
        NSInteger nextIndex = 0;
        if (index > self.willIndex) {
            nextIndex = index - 1;
        } else if (index < self.willIndex){
            nextIndex = index + 1;
        }
        [self callBackWithIndex:nextIndex];
    }
}

- (void)selectedIndex:(NSInteger)index{
    __weak FJSlidingController *weakSelf = self;
    if (self.currentIndex == 0) {
        [self.pageController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            [weakSelf callBackWithIndex:index];
        }];
    } else if (self.currentIndex < index) {
        [self.pageController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            [weakSelf callBackWithIndex:index];
        }];
    } else {
        [self.pageController setViewControllers:@[self.viewControllers[index]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            [weakSelf callBackWithIndex:index];
        }];
    }
    
}

- (void)callBackWithIndex:(NSInteger)index{
    self.currentIndex = index;
    if ([self.delegate respondsToSelector:@selector(fjSlidingController:controllerAtIndex:)]) {
        [self.delegate fjSlidingController:self selectedController:self.viewControllers[index]];
    }
    if ([self.delegate respondsToSelector:@selector(fjSlidingController:selectedIndex:)]) {
        [self.delegate fjSlidingController:self selectedIndex:index];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
