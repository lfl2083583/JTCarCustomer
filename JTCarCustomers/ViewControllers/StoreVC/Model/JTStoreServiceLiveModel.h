//
//  JTStoreServiceLiveModel.h
//  JTCarCustomers
//
//  Created by jt on 2018/5/25.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

//"camera_id" = 5;
//"camera_name" = "\U4fdd\U517b1\U53f7\U5de5\U4f4d1\U53f7\U6444\U50cf\U5934";
//"device_status" = 0;
//"live_hls" = "http://hls.open.ys7.com/openlive/4d174a52e2544be6bd6eb143c70e6fc9.m3u8";
//"live_hls_hd" = "http://hls.open.ys7.com/openlive/4d174a52e2544be6bd6eb143c70e6fc9.hd.m3u8";
//"live_rtmp" = "rtmp://rtmp.open.ys7.com/openlive/4d174a52e2544be6bd6eb143c70e6fc9";
//"live_rtmp_hd" = "rtmp://rtmp.open.ys7.com/openlive/4d174a52e2544be6bd6eb143c70e6fc9.hd";
//"live_status" = 1;
//"pic_url" = "https://i.ys7.com/assets/imgs/public/homeDevice.jpeg";
//"station_id" = 2;
//"station_name" = "\U4fdd\U517b\U5de5\U4f4d1\U53f7";
//"station_status" = 1;

@interface JTStoreServiceLiveModel : NSObject

@property (copy, nonatomic) NSString *coverUrlString;
@property (assign, nonatomic) BOOL liveStatus;

@end
