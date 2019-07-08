//
//  SearchViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/6/29.
//  Copyright © 2019 macbookpro. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //导航栏
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    mAddressLocationLabel = [self createLabelWithFrame:CGRectMake(43, SafeAreaTopHeight, SCREEN_WIDTH - 43*2, 30) :14 :@"Arial" :[UIColor colorWithRed:58/255.0 green:60/255.0 blue:64/255.0 alpha:1.0] :NSTextAlignmentLeft];
    mAddressLocationLabel.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0].CGColor;
    mAddressLocationLabel.layer.borderWidth = 1.0;
    mAddressLocationLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    mAddressLocationLabel.text = @" 请选择地址";
    mAddressLocationLabel.userInteractionEnabled = YES;
    [self.view addSubview:mAddressLocationLabel];
    //添加选择地址点击事件
    UITapGestureRecognizer *tapAddress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress:)];
    [mAddressLocationLabel addGestureRecognizer:tapAddress];
    
    mDateLabel = [self createLabelWithFrame:CGRectMake(43, mAddressLocationLabel.frame.origin.y + mAddressLocationLabel.frame.size.height + 5, SCREEN_WIDTH - 43*2, 30) :14 :@"Arial" :[UIColor colorWithRed:58/255.0 green:60/255.0 blue:64/255.0 alpha:1.0] :NSTextAlignmentLeft];
    mDateLabel.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0].CGColor;
    mDateLabel.layer.borderWidth = 1.0;
    mDateLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    mDateLabel.text = @" 请选择入住时间";
    [self.view addSubview:mDateLabel];
    //添加选择地址点击事件
    mDateLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapDate = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectDate:)];
    [mDateLabel addGestureRecognizer:tapDate];
    
    mHomeNameLabel = [self createLabelWithFrame:CGRectMake(43, mDateLabel.frame.origin.y + mDateLabel.frame.size.height + 5, SCREEN_WIDTH - 43*2, 30) :14 :@"Arial" :[UIColor colorWithRed:58/255.0 green:60/255.0 blue:64/255.0 alpha:1.0] :NSTextAlignmentLeft];
    mHomeNameLabel.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1.0].CGColor;
    mHomeNameLabel.layer.borderWidth = 1.0;
    mHomeNameLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1.0];
    mHomeNameLabel.text = @" 位置/地标/房源名称";
    mHomeNameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapHomeName = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectHomeName:)];
    [mHomeNameLabel addGestureRecognizer:tapHomeName];
    
    //设置显示模式为永远显示(默认不显示 必须设置 否则没有效果)
    [self.view addSubview:mHomeNameLabel];
    
    mFindBtn = [self createButtonWithFrame:CGRectMake(43, mHomeNameLabel.frame.origin.y + mHomeNameLabel.frame.size.height + 11, SCREEN_WIDTH - 43*2, 30) :@"查找" :@selector(findButtonClick:)];
    mFindBtn.backgroundColor = [UIColor colorWithRed:21.0/255.0 green:144.0/255.0 blue:253.0/255.0 alpha:1.0];
    [mFindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    mFindBtn.layer.cornerRadius = 4;
    [self.view addSubview:mFindBtn];
}
#pragma mark - UI控件创建
- (UILabel *)createLabelWithFrame:(CGRect)frame :(CGFloat)fontSize :(NSString *)fontName :(UIColor *)fontColor :(NSTextAlignment)alignment{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.font = [UIFont fontWithName:fontName size:fontSize];
    label.textColor = fontColor;
    label.textAlignment = alignment;
    return label;
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
- (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(SEL)pressEvent{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    [image setAccessibilityIdentifier:@"uncollect"];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:pressEvent forControlEvents:UIControlEventTouchUpInside];
    return button;
}
#pragma mark - 动态事件
- (void)findButtonClick:(id)sender{
    SearchResultViewController *searchVC = [[SearchResultViewController alloc]initWithAddress:mAddressLocationLabel.text AndDate:mDateLabel.text AndName:mHomeNameLabel.text];
    [self.navigationController pushViewController:searchVC animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [mHomeNameLabel resignFirstResponder]; // 空白处收起
}
- (void)selectAddress:(id)sender{
    SelectAddressViewController *selectAddressVC = [[SelectAddressViewController alloc]init];
    selectAddressVC.selectValueBlock = ^(NSString *addressName){
        self->mAddressLocationLabel.text = [NSString stringWithFormat:@" %@",addressName];
        self->mAddressLocationLabel.textColor = [UIColor colorWithRed:58.0/255.0 green:60.0/255.0 blue:64.0/255.0 alpha:1.0];
    };
    [self.navigationController pushViewController:selectAddressVC animated:YES];
}
- (void)selectDate:(id)sender{
    HotelCalendarViewController *vc = [[HotelCalendarViewController alloc] init];
    [vc setSelectCheckDateBlock:^(NSString *startDateStr, NSString *endDateStr, NSString *daysStr) {
        self->mDateLabel.text = [NSString stringWithFormat:@"%@ ~ %@ %@晚",startDateStr,endDateStr,daysStr];
        self->mDateLabel.textColor = [UIColor colorWithRed:58.0/255.0 green:60.0/255.0 blue:64.0/255.0 alpha:1.0];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)selectHomeName:(id)sender{
    SearchNameViewController *vc = [[SearchNameViewController alloc] init];
    [vc setSelectValueBlock:^(NSString *homeName) {
        self->mHomeNameLabel.text = homeName;
        self->mHomeNameLabel.textColor = [UIColor colorWithRed:58.0/255.0 green:60.0/255.0 blue:64.0/255.0 alpha:1.0];
    }];
    [self.navigationController pushViewController:vc animated:YES];
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
