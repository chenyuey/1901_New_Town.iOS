//
//  SearchResultViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/7/2.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import "SearchResultViewController.h"

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController
- (id)initWithAddress:(NSString *)address AndDate:(NSString *)strDate AndName:(NSString *)strName{
    self = [super init];
    if (self) {
        mStrAddress = address;
        mStrDate = strDate;
        mStrHomeName = strName;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    self.tabBarController.tabBar.hidden=YES;
    self.backButton = [self createButtonWithImage:CGRectMake(10, SafeStatusBarHeight+10+8, 24, 24) :@"back_btn" :@selector(backToSearch:)];
    [self.view addSubview:self.backButton];
    mSearchShowView = [self createSearchShowViewWithFrame:CGRectMake(35, SafeStatusBarHeight + 10, SCREEN_WIDTH - 35 - 11, 40)];
}
#pragma mark - UI控件创建
- (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
}
- (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(SEL)pressEvent{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    [image setAccessibilityIdentifier:@"uncollect"];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:pressEvent forControlEvents:UIControlEventTouchUpInside];
    return button;
}
-(UIButton *)createButtonWithFrame:(CGRect)frame :(NSString *)title :(SEL)event{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:event forControlEvents:UIControlEventTouchUpInside];
    //添加文字颜色
    [button setFont:[UIFont systemFontOfSize:14.0f]];
    return button;
}
- (UIView *)createSearchShowViewWithFrame:(CGRect)frame{
    UIView *showSearchItemView = [[UIView alloc]initWithFrame:frame];
    [self.view addSubview:showSearchItemView];
    showSearchItemView.layer.cornerRadius = 20.0;
    showSearchItemView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    return showSearchItemView;
}
#pragma mark - 自定义事件
- (void)backToSearch:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
