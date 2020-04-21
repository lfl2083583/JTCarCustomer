//
//  JTActivityLoctionView.h
//  JTCarCustomers
//
//  Created by lious on 2018/4/23.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@protocol JTActivityLoctionViewDelegate <NSObject>

- (void)updateLocationAgain;

- (void)transportationTypeChoosed:(MKDirectionsTransportType)transportType;

- (void)startNavDistionation;

@end

@interface JTActivityLoctionView : UIView

@property (weak, nonatomic) IBOutlet UIButton *driveBtn;
@property (weak, nonatomic) IBOutlet UIButton *walkBtn;
@property (weak, nonatomic) IBOutlet UILabel *currentLoctionLB;
@property (weak, nonatomic) IBOutlet UIButton *startLoctionBtn;
@property (weak, nonatomic) IBOutlet UILabel *destinationLB;
@property (weak, nonatomic) IBOutlet UILabel *routeLB;

@property (nonatomic, weak) id<JTActivityLoctionViewDelegate>delegate;

@end
