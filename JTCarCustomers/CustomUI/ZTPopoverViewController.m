//
//  ZTPopoverViewController.m
//  JTSocial
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 JTTeam. All rights reserved.
//

#import "ZTPopoverViewController.h"

@implementation ZTPopoverModel

- (instancetype)initWithTextFont:(UIFont *)textfont textColor:(UIColor *)textColor selectTextColor:(UIColor *)selectTextColor iconArr:(NSArray *)iconArr titleArr:(NSArray *)titleArr doneBlock:(void (^)(NSInteger))doneBlock
{
    self = [super init];
    if (self) {
        self.textFont = textfont;
        self.textColor = textColor;
        self.selectTextColor = selectTextColor;
        self.iconArr = iconArr;
        self.titleArr = titleArr;
        self.doneBlock = doneBlock;
    }
    return self;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = (textFont)?textFont:Font(14);
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = (textColor)?textColor:BlackLeverColor5;
}

@end

@interface ZTPopoverViewController () <UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@end

@implementation ZTPopoverViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _selectIndex = -1;
//        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.delegate = self;
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUnknown; //箭头方向,如果是baritem不设置方向，会默认up，up的效果也是最理想的
        self.popoverPresentationController.backgroundColor = WhiteColor;
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"ZTPopoverViewController释放了");
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.scrollEnabled = NO;
        _tableview.separatorColor = BlackLeverColor2;
    }
    return _tableview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.font = self.model.textFont;
        cell.textLabel.textColor = self.model.textColor;
    }
    cell.textLabel.textColor = (indexPath.row == self.selectIndex)?self.model.selectTextColor:self.model.textColor;
    if (self.model.iconArr && self.model.iconArr.count > indexPath.row) {
        cell.imageView.image = [UIImage imageNamed:self.model.iconArr[indexPath.row]];
    }
    if (self.model.titleArr && self.model.titleArr.count > indexPath.row) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", self.model.titleArr[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    if (self.model.doneBlock) {
        self.model.doneBlock(indexPath.row);
    }
}

- (CGSize)preferredContentSize {
    if (self.presentingViewController && self.tableview != nil) {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 135;
        CGSize size = [self.tableview sizeThatFits:tempSize];  //sizeThatFits返回的是最合适的尺寸，但不会改变控件的大小
        return size;
    } else {
        return [super preferredContentSize];
    }
}

- (void)setPreferredContentSize:(CGSize)preferredContentSize {
    super.preferredContentSize = preferredContentSize;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
