//
//  QRHeader.h
//  HCSystemicQRCodeDemo
//
//  Created by Caoyq on 16/5/4.
//  Copyright © 2016年 honeycao. All rights reserved.
//

#ifndef QRHeader_h
#define QRHeader_h

#define iPhone5Ratio         [[UIScreen mainScreen] bounds].size.width/320.0

#define kFrameLeft           45*iPhone5Ratio
#define kFrameTop            80*iPhone5Ratio
#define kFrameWidth          230*iPhone5Ratio
#define kFrameHeight         230*iPhone5Ratio

#define kScrollLineHeight    7.5*iPhone5Ratio
#define kScrollLineWidth     200*iPhone5Ratio

#define kTipY                (kFrameTop+kFrameWidth+kTipHeight)
#define kTipHeight           20*iPhone5Ratio

#define kButtonWidth         80*iPhone5Ratio
#define kButtonSpace         20*iPhone5Ratio

#define kBgAlpha             0.3

static NSString *bgImg_img = @"image.bundle/scanBackground";
static NSString *Line_img  = @"image.bundle/scanLine";
static NSString *album_nor   = @"image.bundle/qrcode_scan_btn_album_nor";
static NSString *album_down  = @"image.bundle/qrcode_scan_btn_album_down";
static NSString *lamp_on     = @"image.bundle/qrcode_scan_btn_lump_no";
static NSString *lamp_off    = @"image.bundle/qrcode_scan_btn_lump_off";
static NSString *code_nor    = @"image.bundle/qrcode_scan_btn_code_nor";
static NSString *code_down   = @"image.bundle/qrcode_scan_btn_code_down";
static NSString *ringPath  = @"image.bundle/ring";
static NSString *ringType  = @"wav";

#endif /* QRHeader_h */
