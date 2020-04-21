//
//  JTPersonalTagInputViewController.m
//  JTCarCustomers
//
//  Created by lious on 2018/3/12.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTPersonalTagInputViewController.h"
#import "ZTTextField.h"

@interface JTPersonalTagInputViewController ()

@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) ZTTextField *inputTF;

@property (nonatomic, assign) NSInteger tagType;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) NSString *subtitle;

@end

@implementation JTPersonalTagInputViewController

- (instancetype)initWithJTTagType:(NSInteger)tagType tagInput:(ZTTagInputBlock)callBack {
    if (self = [super init]) {
        self.tagType = tagType;
        [self setCallBack:callBack];
    }
    return self;
}

- (instancetype)initWithIndexPath:(NSIndexPath *)indexPath title:(NSString *)title textInput:(ZTTextInputBlock)textCallBack {
    if (self = [super init]) {
        self.indexPath = indexPath;
        self.subtitle = title;
        [self setTextCallBack:textCallBack];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.topLabel];
    [self.view addSubview:self.inputTF];
    self.view.backgroundColor = WhiteColor;
    if (self.subtitle) {
        self.topLabel.text = self.subtitle;
        if ([self.subtitle isEqualToString:@"昵称"]) {
            self.inputTF.placeholder = @"昵称为2~9个字符";
        } else if ([self.subtitle isEqualToString:@"公司"]) {
            self.inputTF.placeholder = @"公司名为2~18个字符";
        } else if ([self.subtitle isEqualToString:@"个性签名"]) {
            self.inputTF.placeholder = @"个新签名为2~15个字符";
        }
    } else {
        self.inputTF.placeholder = @"自定义标签文案不得超过8字符";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClick:)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setShadowImage:nil];
}


/**
   保存

 @param sender UIBarButtonItem
 */
- (void)rightItemClick:(id)sender{
    if (self.tagType) {
        if (!self.inputTF.text.length) {
            [[HUDTool shareHUDTool] showHint:@"请输入自定义标签" yOffset:0];
            return;
        }
        if (self.inputTF.text.length > 8) {
            [[HUDTool shareHUDTool] showHint:@"自定义标签不得超过8个字符" yOffset:0];
            return;
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"0" forKey:@"label_id"];
        [dict setValue:self.inputTF.text forKey:@"label_name"];
        if (self.callBack) {
            self.callBack(dict);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        if (self.subtitle && [self.subtitle isEqualToString:@"昵称"] &&(self.inputTF.text.length < 2 || self.inputTF.text.length > 9)) {
            [[HUDTool shareHUDTool] showHint:@"昵称为2~9个字符" yOffset:0];
            return;
        } else if (self.subtitle && [self.subtitle isEqualToString:@"公司"] &&(self.inputTF.text.length < 2 || self.inputTF.text.length > 18)) {
            [[HUDTool shareHUDTool] showHint:@"公司名为2~18个字符" yOffset:0];
            return;
        } else if (self.subtitle && [self.subtitle isEqualToString:@"个性签名"] &&(self.inputTF.text.length < 2 || self.inputTF.text.length > 15)) {
            [[HUDTool shareHUDTool] showHint:@"个新签名为2~15个字符" yOffset:0];
            return;
        }
        
        if (self.textCallBack) {
            self.textCallBack(self.inputTF.text, self.indexPath);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, kStatusBarHeight + kTopBarHeight - 2, App_Frame_Width - 44, 40)];
        _topLabel.font = Font(24);
        _topLabel.text = @"创建自定义";
    }
    return _topLabel;
}

- (ZTTextField *)inputTF{
    if (!_inputTF) {
        _inputTF = [[ZTTextField alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(self.topLabel.frame) + 20, App_Frame_Width - 44, 40)];
        _inputTF.font = Font(14);
        _inputTF.layer.borderWidth = 1;
        _inputTF.layer.cornerRadius = 4;
        _inputTF.layer.borderColor = BlackLeverColor2.CGColor;
        _inputTF.layer.masksToBounds = YES;
    }
    return _inputTF;
}

@end
