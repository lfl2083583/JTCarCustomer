//
//  JTRealCertificationView.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/22.
//  Copyright © 2018年 JTTeam. All rights reserved.
//
#import "ZTFileNameTool.h"
#import "ZTObtainPhotoTool.h"
#import "JTWordItem.h"
#import "JTRealCertificationView.h"
#import "JTTFTitleTableViewCell.h"


@interface JTRealCertificationAuditView ()

@property (nonatomic, strong) UIImageView *centerImagV;
@property (nonatomic, strong) UILabel *bottomLB;

@end

@implementation JTRealCertificationAuditView

- (instancetype)initWithFrame:(CGRect)frame realCertificationStatus:(JTRealCertificationStatus)status {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        self.backgroundColor = WhiteColor;
        if (status == JTRealCertificationStatusApproved) {
            self.centerImagV.image = [UIImage imageNamed:@"center_real_audit"];
            self.bottomLB.text = @"已完成实名认证";
        }else if (status == JTRealCertificationStatusAudit) {
            self.centerImagV.image = [UIImage imageNamed:@"center_real_unaudit"];
            self.bottomLB.text = @"已提交实名认证申请";
            UILabel *kbottomLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.bottomLB.frame)+5, self.bounds.size.width, 22)];
            kbottomLB.font = Font(16);
            kbottomLB.textColor = BlackLeverColor3;
            kbottomLB.textAlignment = NSTextAlignmentCenter;
            kbottomLB.text = @"1-3个工作日内审核完成，请耐心等待审核";
            [self addSubview:kbottomLB];
        }
    }
    return self;
}

- (void)bottomBtnClick:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
}

- (void)setupViews {
    JTRealCertificationHeadView *topView = [[JTRealCertificationHeadView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, self.bounds.size.width, 50)];
    topView.leftLB.text = @"实名认证";
    
    UIImageView *centerImagV = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width-210)/2.0, CGRectGetMaxY(topView.frame)+10, 210, 210)];
    self.centerImagV = centerImagV;
    
    UILabel *bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(centerImagV.frame), self.bounds.size.width-30, 25)];
    bottomLB.font = Font(18);
    bottomLB.textColor = BlueLeverColor1;
    bottomLB.textAlignment = NSTextAlignmentCenter;
    self.bottomLB = bottomLB;
    
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width-80)/2.0, self.bounds.size.height-80, 80, 40)];
    bottomBtn.titleLabel.font = Font(14);
    [bottomBtn setTitleColor:BlueLeverColor1 forState:UIControlStateNormal];
    [bottomBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:topView];
    [self addSubview:centerImagV];
    [self addSubview:bottomLB];
    [self addSubview:bottomBtn];
}

@end

@implementation JTRealCertificationHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftLB];
        self.backgroundColor = WhiteColor;
    }
    return self;;
}

- (UILabel *)leftLB {
    if (!_leftLB) {
        _leftLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.bounds.size.width-15, 40)];
        _leftLB.font = Font(24);
    }
    return _leftLB;
}


@end

@implementation JTRealCertificationFootView

- (void)cardBtnClick:(UIButton *)sender {
    __weak typeof(self)weakSelf = self;
    [[ZTObtainPhotoTool shareObtainPhotoTool] show:[Utility currentViewController] photoEditType:JTPhotoEditTypeDisable success:^(UIImage *image) {
        [sender setImage:image forState:UIControlStateNormal];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(realCertificationViewPhotoChoosedIndex:image:)]) {
            [weakSelf.delegate realCertificationViewPhotoChoosedIndex:sender.tag image:image];
        }
    } cancel:^{
        
    }];
}

- (void)bottomBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(realCertificationViewComfirmBtnClick:)]) {
        [_delegate realCertificationViewComfirmBtnClick:sender];
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
        self.backgroundColor = BlackLeverColor1;
    }
    return self;
}

- (void)setupViews {
    CGFloat width = (self.bounds.size.width-40)/2.0;
    CGFloat height = 11*width/16;
    NSArray *array = @[@"身份证正面", @"身份证反面", @"手持身份证正面"];
    for (int i = 0; i < array.count+1; i++) {
        if (i < array.count) {
            UIView *bottomView = [self creatIDCardUploadViewTitle:array[i] rect:CGRectMake(15+(width+10)*(i%2), 18+(height+10)*(i/2), width, height)];
            [self addSubview:bottomView];
        }
        UIButton *cardBtn = [[UIButton alloc] initWithFrame:CGRectMake(15+(width+10)*(i%2), 18+(height+10)*(i/2), width, height)];
        cardBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cardBtn.clipsToBounds = YES;
        [cardBtn setTag:i];
        [cardBtn addTarget:self action:@selector(cardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (i == array.count) {
            [cardBtn setImage:[UIImage imageNamed:@"center_real_card"] forState:UIControlStateNormal];
            cardBtn.enabled = NO;
        }
        [self addSubview:cardBtn];
    }
    
    JTGradientButton *bottomBtn = [[JTGradientButton alloc] initWithFrame:CGRectMake((self.width - 300) / 2.0, height*2+45, 300, 45)];
    [self addSubview:bottomBtn];
    bottomBtn.titleLabel.font = Font(16);
    [bottomBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomBtn setTitleColor:WhiteColor forState:UIControlStateNormal];
    [bottomBtn setTitle:@"提交" forState:UIControlStateNormal];
    self.bottomBtn = bottomBtn;
    
    UILabel *bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bottomBtn.frame)+10, self.bounds.size.width, 18)];
    bottomLB.font = Font(12);
    bottomLB.textColor = BlackLeverColor3;
    bottomLB.textAlignment = NSTextAlignmentCenter;
    bottomLB.text = @"实名认证信息仅作审核使用，平台将会对信息做保密处理";
    [self addSubview:bottomLB];
}

- (UIView *)creatIDCardUploadViewTitle:(NSString *)title rect:(CGRect)rect {
    UIView *view = [[UIView alloc] initWithFrame:rect];
    view.backgroundColor = WhiteColor;
    UIImageView *topImageV = [[UIImageView alloc] initWithFrame:CGRectMake((rect.size.width-30)/2.0, 27, 30, 30)];
    topImageV.image = [UIImage imageNamed:@"photo_add_icon"];
    [view addSubview:topImageV];
    UILabel *bottomLB = [[UILabel alloc] initWithFrame:CGRectMake(0, rect.size.height-43, rect.size.width, 22)];
    bottomLB.textAlignment = NSTextAlignmentCenter;
    bottomLB.font = Font(16);
    bottomLB.textColor = BlackLeverColor3;
    bottomLB.text = title;
    [view addSubview:bottomLB];
    return view;
}

@end

@interface JTRealCertificationView () <UITableViewDelegate, UITableViewDataSource, JTRealCertificationViewDelegate, JTTFTitleTableViewCellDelegate>

@property (nonatomic, strong) JTRealCertificationHeadView *headView;
@property (nonatomic, strong) JTRealCertificationFootView *footView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIImage *IDCardImge1;
@property (nonatomic, strong) UIImage *IDCardImge2;
@property (nonatomic, strong) UIImage *IDCardImge3;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *IDNum;
@property (nonatomic, copy) NSString *phoneNum;


@end

@implementation JTRealCertificationView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupComponent];
        [self addSubview:self.tableView];
        self.tableView.tableHeaderView = self.headView;
        self.tableView.tableFooterView = self.footView;
        self.backgroundColor = WhiteColor;
        [self.tableView reloadData];
    }
    return self;
}

- (void)setupComponent {
    JTWordItem *item1 = [self creatItemWithTitle:@"真实姓名" placeHolder:@"请填写真实姓名"];
    JTWordItem *item2 = [self creatItemWithTitle:@"身份证号" placeHolder:@"请填写真实身份证号码"];
    JTWordItem *item3 = [self creatItemWithTitle:@"联系电话" placeHolder:@"当前可联系到本人的电话号码"];
    self.dataArray = @[item1, item2, item3];
}

- (JTWordItem *)creatItemWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder {
    JTWordItem *item = [[JTWordItem alloc] init];
    item.title = title;
    item.placeholder = placeHolder;
    return item;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JTWordItem *item = self.dataArray[indexPath.row];
    JTTFTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tfTitleIdentifier];
    cell.delegate = self;
    [cell configCellTitle:item.title subtitle:item.subTitle placeHolder:item.placeholder indexPath:indexPath textfieldEnable:YES];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark JTRealCertificationViewDelegate
- (void)realCertificationViewPhotoChoosedIndex:(NSInteger)index image:(UIImage *)image {
    if (index == 0) {
        self.IDCardImge1 = image;
    } else if (index == 1) {
        self.IDCardImge2 = image;
    } else {
        self.IDCardImge3 = image;
    }
}

- (void)realCertificationViewComfirmBtnClick:(id)sender {
    CCLOG(@"提交");
    if (!self.realName || [self.realName isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入真实姓名" yOffset:0];
        return;
    }
    if (!self.IDNum || [self.IDNum isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入身份证号码" yOffset:0];
        return;
    }
    if (!self.phoneNum || [self.phoneNum isBlankString]) {
        [[HUDTool shareHUDTool] showHint:@"请输入手机号码" yOffset:0];
        return;
    }
    if (self.phoneNum && [self.phoneNum isKindOfClass:[NSString class]] && self.phoneNum.length != 11) {
        [[HUDTool shareHUDTool] showHint:@"请输入正确的手机号码" yOffset:0];
        return;
    }
    if (!self.IDCardImge1 || !self.IDCardImge2 || !self.IDCardImge3) {
        [[HUDTool shareHUDTool] showHint:@"请上传身份证照片" yOffset:0];
        return;
    }
    [[HttpRequestTool sharedInstance] uploadWithFileNames:[ZTFileNameTool showFileNamesForVeriFileNum:3] uploadFileArr:@[self.IDCardImge1,self.IDCardImge2,self.IDCardImge3] success:^(id responseObject) {
        NSArray *array = responseObject;
        if (array && [array isKindOfClass:[NSArray class]] && array.count == 3) {
            NSMutableDictionary *pragrem = [NSMutableDictionary dictionary];
            [pragrem setValue:self.realName forKey:@"real_name"];
            [pragrem setValue:self.IDNum forKey:@"card"];
            [pragrem setValue:self.phoneNum forKey:@"phone"];
            [pragrem setValue:[NSString stringWithFormat:@"%@",array[0]] forKey:@"card_pic_1"];
            [pragrem setValue:[NSString stringWithFormat:@"%@",array[1]] forKey:@"card_pic_2"];
            [pragrem setValue:[NSString stringWithFormat:@"%@",array[2]] forKey:@"card_pic_3"];
            [[HttpRequestTool sharedInstance] postWithURLString:kBase_url(RealCertificationApi) parameters:pragrem success:^(id responseObject, ResponseState state) {
                CCLOG(@"%@",responseObject);
                [[Utility currentViewController].navigationController popViewControllerAnimated:YES];
                [JTUserInfo shareUserInfo].userAuthStatus = 2;
                [[JTUserInfo shareUserInfo] save];
            } failure:^(NSError *error) {
                
            }];
        }
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark JTTFTitleTableViewCellDelegate
- (void)titleTableViewCellTfChanged:(NSString *)content indexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        self.realName = content;
    } else if (indexPath.row == 1) {
        self.IDNum = content;
    } else {
        self.phoneNum = content;
    }
}

- (JTRealCertificationHeadView *)headView {
    if (!_headView) {
        _headView = [[JTRealCertificationHeadView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 50)];
        _headView.leftLB.text = @"实名认证";
    }
    return _headView;
}

- (JTRealCertificationFootView *)footView {
    if (!_footView) {
        CGFloat height = 11*(self.bounds.size.width-40)/16+200;
        _footView = [[JTRealCertificationFootView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, height)];
        _footView.delegate = self;
    }
    return _footView;
}

- (UITableView *)tableView {
    if (!_tableView ){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight+kTopBarHeight, self.bounds.size.width, APP_Frame_Height-kStatusBarHeight+kTopBarHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerNib:[UINib nibWithNibName:@"JTTFTitleTableViewCell" bundle:nil] forCellReuseIdentifier:tfTitleIdentifier];;
    }
    return _tableView;
}

@end
