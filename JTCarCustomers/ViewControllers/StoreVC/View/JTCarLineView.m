//
//  JTCarLineView.m
//  JTCarCustomers
//
//  Created by jt on 2018/4/28.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTCarLineView.h"
#import "ZTTableViewHeaderFooterView.h"

@interface JTCarLineView () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableview;

@end

@implementation JTCarLineView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<JTCarLineViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDelegate:delegate];
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0]];
        [self addSubview:self.tableview];
        [self.tableview registerClass:[ZTTableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:headerFooterIdentifier];
        [self setHidden:YES];
    }
    return self;
}

- (void)showDataArray:(NSArray *)dataArray;
{
    [self setHidden:NO];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.15 animations:^{
        weakself.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
        weakself.tableview.left = weakself.width/3;
    }];
    _dataArray = dataArray;
    [self.tableview reloadData];
}

- (void)hide
{
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:.15 animations:^{
        weakself.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        weakself.tableview.left = weakself.width;
    } completion:^(BOOL finished) {
        if (finished) {
            weakself.hidden = YES;
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray[section] objectForKey:@"series_list"] count];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ZTTableViewHeaderFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterIdentifier];
    footer.promptLB.text = [self.dataArray[section] objectForKey:@"factory_name"];
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = Font(14);
        cell.textLabel.textColor = BlackLeverColor6;
    }
    NSDictionary *source = [[self.dataArray[indexPath.section] objectForKey:@"series_list"] objectAtIndex:indexPath.row];
    [cell.textLabel setText:source[@"series_name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *source = [[self.dataArray[indexPath.section] objectForKey:@"series_list"] objectAtIndex:indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(carLineView:didSelectAtSoucre:)]) {
        [_delegate carLineView:self didSelectAtSoucre:source];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.tableview.frame, touchPoint)) {
        [self hide];
    }
}

- (UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectMake(self.width, 0, self.width*2/3, self.height) style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.backgroundColor = WhiteColor;
        _tableview.showsVerticalScrollIndicator = NO;
        _tableview.rowHeight = 44;
        _tableview.estimatedRowHeight = 44;
        _tableview.sectionHeaderHeight = 25;
        _tableview.estimatedSectionHeaderHeight = 25;
        _tableview.sectionFooterHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
        _tableview.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    }
    return _tableview;
}

@end
