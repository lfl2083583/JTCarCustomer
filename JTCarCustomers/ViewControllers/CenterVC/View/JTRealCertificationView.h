//
//  JTRealCertificationView.h
//  JTCarCustomers
//
//  Created by lious on 2018/3/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTGradientButton.h"
#import "JTUserInfo.h"


@protocol JTRealCertificationViewDelegate <NSObject>

- (void)realCertificationViewPhotoChoosedIndex:(NSInteger)index image:(UIImage *)image;

- (void)realCertificationViewComfirmBtnClick:(id)sender;

@end

@interface JTRealCertificationAuditView : UIView

- (instancetype)initWithFrame:(CGRect)frame realCertificationStatus:(JTRealCertificationStatus)status;

@end


@interface JTRealCertificationHeadView : UIView

@property (nonatomic, strong) UILabel *leftLB;

@end

@interface JTRealCertificationFootView : UIView

@property (nonatomic, strong) JTGradientButton *bottomBtn;
@property (nonatomic, weak) id<JTRealCertificationViewDelegate>delegate;

@end


@interface JTRealCertificationView : UIView

@end
