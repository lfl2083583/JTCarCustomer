//
//  JTConfigurationParameterView.m
//  JTCarCustomers
//
//  Created by jt on 2018/5/4.
//  Copyright © 2018年 JTTeam. All rights reserved.
//

#import "JTConfigurationParameterView.h"

@implementation JTConfigurationParameterView 

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.fDataSource = self;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self reloadData];
}

- (FTopLeftHeaderView *)topLeftHeadViewForForm:(FormScrollView *)formScrollView {
    FTopLeftHeaderView *view = [formScrollView dequeueReusableTopLeftView];
    if (view == NULL) {
        view = [[FTopLeftHeaderView alloc] init];
        [view setTitleColor:BlackLeverColor6 forState:UIControlStateNormal];
        [view.titleLabel setFont:Font(12)];
    }
    [view setTitle:[[self.dataArray objectAtIndex:0] objectAtIndex:0] forState:UIControlStateNormal];
    return view;
}
- (NSInteger)numberOfSection:(FormScrollView *)formScrollView {
    return self.dataArray.count - 1;
}
- (NSInteger)numberOfColumn:(FormScrollView *)formScrollView {
    return [[self.dataArray objectAtIndex:0] count] - 1;
}
- (CGFloat)heightForHeader:(FormScrollView *)formScrollView {
    return 40;
}
- (CGFloat)heightForSection:(FormScrollView *)formScrollView {
    return 30;
}
- (CGFloat)widthForColumn:(FormScrollView *)formScrollView {
    return self.width/2;
}
- (FormSectionHeaderView *)form:(FormScrollView *)formScrollView sectionHeaderAtSection:(NSInteger)section {
    FormSectionHeaderView *header = [formScrollView dequeueReusableSectionWithIdentifier:@"Section"];
    if (header == NULL) {
        header = [[FormSectionHeaderView alloc] initWithIdentifier:@"Section"];
        [header setTitleColor:BlackLeverColor6 forState:UIControlStateNormal];
        [header.titleLabel setFont:Font(12)];
    }
    [header setTitle:[[self.dataArray objectAtIndex:section+1] objectAtIndex:0] forState:UIControlStateNormal];
    return header;
}
- (FormColumnHeaderView *)form:(FormScrollView *)formScrollView columnHeaderAtColumn:(NSInteger)column {
    FormColumnHeaderView *header = [formScrollView dequeueReusableColumnWithIdentifier:@"Column"];
    if (header == NULL) {
        header = [[FormColumnHeaderView alloc] initWithIdentifier:@"Column"];
        [header setTitleColor:BlackLeverColor6 forState:UIControlStateNormal];
        [header.titleLabel setFont:Font(12)];
    }
    [header setTitle:[[self.dataArray objectAtIndex:0] objectAtIndex:column+1] forState:UIControlStateNormal];
    return header;
}
- (FormCell *)form:(FormScrollView *)formScrollView cellForColumnAtIndexPath:(FIndexPath *)indexPath {
    FormCell *cell = [formScrollView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == NULL) {
        cell = [[FormCell alloc] initWithIdentifier:@"Cell"];
        [cell setTitleColor:BlackLeverColor6 forState:UIControlStateNormal];
        [cell.titleLabel setFont:Font(12)];
    }
    [cell setTitle:[[self.dataArray objectAtIndex:indexPath.section+1] objectAtIndex:indexPath.column+1] forState:UIControlStateNormal];
    return cell;
}

@end
