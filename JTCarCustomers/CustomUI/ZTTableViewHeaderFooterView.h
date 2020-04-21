//
//  ZTTableViewHeaderFooterView.h
//  JTSocial
//
//  Created by apple on 2017/6/24.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZTAlignmentLabel.h"

static NSString *headerFooterIdentifier = @"ZTTableViewHeaderFooterView";

@interface ZTTableViewHeaderFooterView : UITableViewHeaderFooterView

@property (strong, nonatomic) ZTAlignmentLabel *promptLB;
@end
