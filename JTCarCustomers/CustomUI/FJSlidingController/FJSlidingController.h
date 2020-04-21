//
//  FJSlidingController.h
//  FJSlidingController
//
//  Created by fujin on 15/12/17.
//  Copyright © 2015年 fujin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FJSlidingControllerDataSource;
@protocol FJSlidingControllerDelegate;

@interface FJSlidingController : UIViewController
@property (nonatomic, strong)UIPageViewController *pageController;
@property (nonatomic, assign)id<FJSlidingControllerDataSource> datasouce;
@property (nonatomic, assign)id<FJSlidingControllerDelegate> delegate;
@property (nonatomic, assign)BOOL isDisableScroll;
-(void)reloadData;
-(void)selectedIndex:(NSInteger)index;
@end

@protocol FJSlidingControllerDataSource <NSObject>
@required
// pageNumber
- (NSInteger)numberOfPageInFJSlidingController:(FJSlidingController *)fjSlidingController;
// index -> UIViewController
- (UIViewController *)fjSlidingController:(FJSlidingController *)fjSlidingController controllerAtIndex:(NSInteger)index;
// index -> Title
@end

@protocol FJSlidingControllerDelegate <NSObject>
@optional
// selctedIndex
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedIndex:(NSInteger)index;
// selectedController
- (void)fjSlidingController:(FJSlidingController *)fjSlidingController selectedController:(UIViewController *)controller;
@end
