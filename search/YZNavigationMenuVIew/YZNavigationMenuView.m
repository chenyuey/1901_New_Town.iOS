//
//  YZNavigationMenuView.m
//  YZNavigationMenuView
//
//  Created by holden on 2016/12/25.
//  Copyright © 2016年 holden. All rights reserved.
//

#import "YZNavigationMenuView.h"

@interface YZNavigationMenuView ()


@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, strong) UIView *shapeView;

@end

@implementation YZNavigationMenuView

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleArray = titleArray;
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self addSubview:_tableView];

    }
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (_clickedBlock) {
        _clickedBlock(indexPath.row);
    }
    if (_delegate && [_delegate respondsToSelector:@selector(navigationMenuView:clickedAtIndex:)]) {
        [_delegate navigationMenuView:self clickedAtIndex:indexPath.row];
    }
    cell.textLabel.textColor = [UIColor colorWithRed:90.0/255.0 green:169.0/255.0 blue:135.0/255.0 alpha:1.0];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = [UIColor blackColor];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end
