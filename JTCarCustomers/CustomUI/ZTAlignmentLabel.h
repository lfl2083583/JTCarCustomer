//
//  ZTAlignmentLabel.h
//  GCHCustomerMall
//
//  Created by 观潮汇 on 5/1/16.
//  Copyright © 2016 观潮汇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
    
} VerticalAlignment;

@interface ZTAlignmentLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;  
@end
