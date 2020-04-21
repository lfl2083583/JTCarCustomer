//
//  JTScanQRViewController.h
//  JTCarCustomers
//
//  Created by apple on 2017/7/29.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScanCodeQRSystemFunctions.h"

typedef void(^successBlock)(id codeInfo, QRCodeType qrcodeType);
@interface JTScanQRViewController : UIViewController

@property (strong, nonatomic) successBlock block;

/**
 *将扫码成功后获得的 二维码/条形码 信息进行回传
 */
- (void)successfulGetQRCodeInfo:(successBlock)success;

@end
