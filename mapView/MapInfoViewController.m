//
//  MapInfoViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/3/20.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import "MapInfoViewController.h"

@interface MapInfoViewController ()

@end

@implementation MapInfoViewController
- (id)initWithTitle:(NSString *)strTitle{
    self = [super init];
    if (self) {
        self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
        self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
        //修改导航栏样式
        self.navTitleLabel = [self createLabelWithFrame:CGRectMake(50, SafeStatusBarHeight, SCREEN_WIDTH - 100, 44) :20 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
        self.navTitleLabel.text = strTitle;
        [self.view addSubview:self.navTitleLabel];
        self.backButton = [self createButtonWithImage:CGRectMake(20, SafeStatusBarHeight+10, 24, 24) :@"back_btn" :@selector(backToRegion:)];
        [self.view addSubview:self.backButton];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];

    
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
#pragma mark - 页面事件
- (void)backToRegion:(id)sender{
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
