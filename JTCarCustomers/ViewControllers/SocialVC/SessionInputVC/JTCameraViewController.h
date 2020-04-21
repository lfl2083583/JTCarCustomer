//
//  JTCameraViewController.h
//  JTCarCustomers
//
//  Created by apple on 2018/3/17.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTCameraViewController : UIViewController

@property (copy, nonatomic) void (^completionImageHandler)(UIImage *image);
@property (copy, nonatomic) void (^completionVideoHandler)(NSString *videoPath);

- (instancetype)initWithCompletionImageHandler:(void (^)(UIImage *image))completionImageHandler completionVideoHandler:(void (^)(NSString *videoPath))completionVideoHandler;

@end
