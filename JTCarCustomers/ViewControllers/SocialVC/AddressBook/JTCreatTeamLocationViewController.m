//
//  JTCreatTeamLocationViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/15.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "UIImage+Chat.h"
#import "JTGradientButton.h"
#import "JTBaseNavigationController.h"
#import "JTMapPositionViewController.h"
#import "JTCreatTeamLocationViewController.h"

@interface JTCreatTeamLocationViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *leftImgeView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *centerBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

@property (nonatomic, assign) JTTeamPositionType positionType;
@property (nonatomic, copy) NSString *lng;
@property (nonatomic, copy) NSString *lat;
@property (nonatomic, copy) NSString *address;

@end

@implementation JTCreatTeamLocationViewController

- (instancetype)initWithTeam:(NIMTeam *)team callBack:(zt_TeamLoctionInfoBlock)callBack {
    self = [super init];
    if (self) {
        self.team = team;
        [self setCallBack:callBack];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstraint.constant = kStatusBarHeight+kTopBarHeight;
    self.widthConstraint.constant = App_Frame_Width>320?100:80;
    self.leftImgeView.image = [UIImage jt_imageInKit:@"icom_im_location"];
    [self surroundingBtnClick:self.leftBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (IBAction)surroundingBtnClick:(UIButton *)sender {
    self.leftBtn.selected = NO;
    self.rightBtn.selected = NO;
    self.centerBtn.selected = NO;
    self.positionType = sender.tag;
    sender.selected = YES;
}

- (IBAction)nextBtnClick:(JTGradientButton *)sender {
    if (!self.positionType) {
        [[HUDTool shareHUDTool] showHint:@"请选择群组地点" yOffset:0];
        return;
    }
    if (!self.address) {
        [[HUDTool shareHUDTool] showHint:@"请获取你当前位置" yOffset:0];
        return;
    }
    if (self.team) {
        if (self.callBack) {
            self.callBack(self.positionType, self.address, self.lng, self.lat);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self.navigationController pushViewController:[[JTCreatTeamClassifyViewController alloc] initWithTeamNearby:self.positionType lng:self.lng lat:self.lat address:self.address] animated:YES];
    }
}

- (IBAction)loctionBtnClick:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    [JTDeviceAccess checkLocationEnable:@"位置权限受限,无法使用位置" result:^(BOOL result) {
        if (result) {
            NSString *place = @"小区";
            if (self.positionType == JTTeamPositionTypeVillage)
            {
                place = @"小区";
            }
            else if (self.positionType == JTTeamPositionTypeCommercial)
            {
                place = @"商用楼";
            }
            else if (self.positionType == JTTeamPositionTypeSchool)
            {
                place = @"学校";
            }
            JTMapPositionViewController *mapPositionVC = [[JTMapPositionViewController alloc] initWithPlace:place mapType:JTMapTypeCreateGroup];
            [mapPositionVC setMapPositionViewControllerBlock:^(NIMMessage *message) {
                NIMLocationObject *locationObj = (NIMLocationObject *)[message messageObject];
                weakself.lat = [NSString stringWithFormat:@"%f",locationObj.latitude];
                weakself.lng = [NSString stringWithFormat:@"%f",locationObj.longitude];
                NSString *content = locationObj.title;
                NSArray *address = [content componentsSeparatedByString:@"&&&&&&"];
                weakself.address = address[1]?address[1]:address[0];
                weakself.rightLabel.text = weakself.address;
                
            }];
            [weakself presentViewController:[[UINavigationController alloc] initWithRootViewController:mapPositionVC] animated:YES completion:nil];
        }
    }];
}

@end
