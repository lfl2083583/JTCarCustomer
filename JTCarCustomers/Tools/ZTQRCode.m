//
//  ZTQRCode.m
//  JTSocial
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "ZTQRCode.h"

@implementation ZTQRCode

+ (UIImage *)createQRImageWithString:(NSString *)string size:(CGSize)size
{
    return [self createQRImageWithString:string linkSmallIcon:nil size:size];
}

+ (UIImage *)createQRImageWithString:(NSString *)string linkSmallIcon:(UIImage *)icon size:(CGSize)size
{
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    CIImage *qrImage = qrFilter.outputImage;
    // 放大并绘制二维码 (上面生成的二维码很小，需要放大)
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    // 翻转一下图片 不然生成的QRCode就是上下颠倒的
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    if (icon) {
        
        UIGraphicsBeginImageContext(size);
        [codeImage drawInRect:CGRectMake(0, 0, codeImage.size.width, codeImage.size.height)];
        CGFloat imageW = 50;
        CGFloat imageX = (codeImage.size.width - imageW) * 0.5;
        CGFloat imgaeY = (codeImage.size.height - imageW) * 0.5;
        [icon drawInRect:CGRectMake(imageX, imgaeY, imageW, imageW)];
        UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return result;
    }
    else
    {
        return codeImage;
    }
}

@end
