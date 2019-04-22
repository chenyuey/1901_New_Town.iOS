//
//  CollectionViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/3/21.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import "CollectionViewController.h"

@interface CollectionViewController ()

@end

@implementation CollectionViewController
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
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden=NO;
    if (![PFUser currentUser]) {
         [self showLoginViewControllerIfNeeded];
    }else{
        if (self.childViewControllers.count > 0) {
            [self removeLoginViewController];
        }
        if (self.slideBarView.center.x > (SCREEN_WIDTH - 80*2)/2){
            [self findCollectionInfosWithType:1];
            [townButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [self findCollectionInfosWithType:0];
            [categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

#pragma mark -  登录页面的控制
//children 添加到/移除 parent
- (void)updateLoginInfo {
    if ([PFUser currentUser]) {
        if (self.slideBarView.center.x > (SCREEN_WIDTH - 80*2)/2){
            [self findCollectionInfosWithType:1];
            [townButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [self findCollectionInfosWithType:0];
            [categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}
#pragma mark - 系统声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.navigationController.navigationBar.hidden = YES; // 隐藏navigationbar
    self.view.backgroundColor = [UIColor colorWithRed:249.0/255.0 green:249.0/255.0 blue:249.0/255.0 alpha:1.0];
    //修改导航栏样式
    self.navTitleLabel = [self createLabelWithFrame:CGRectMake(0, SafeStatusBarHeight, SCREEN_WIDTH, 44) :20 :@"Arial-BoldM" :[UIColor blackColor] :NSTextAlignmentCenter];
    self.navTitleLabel.text = @"我的收藏";
    [self.view addSubview:self.navTitleLabel];
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeStatusBarHeight+44, SCREEN_WIDTH, SCREEN_HEIGHT - SafeStatusBarHeight - 44 -44 - SafeAreaBottomHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentView];
    UIView *navView = [self cteateNavViewWithFrame:CGRectMake(80, 0, SCREEN_WIDTH - 80*2, 48)];
    [contentView addSubview:navView];
    
    UIView *splitLineView = [[UIView alloc]initWithFrame:CGRectMake(0, navView.frame.size.height, SCREEN_WIDTH, 1)];
    splitLineView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    [contentView addSubview:splitLineView];
    
    mCollectTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 17 + 48, SCREEN_WIDTH, contentView.frame.size.height - 7 - 48) style:UITableViewStylePlain];
    mCollectTableView.dataSource = self;
    mCollectTableView.delegate = self;
    [contentView addSubview:mCollectTableView];
    
    collectionDataSource = @[];
    mCollectTableView.tableFooterView = [[UIView alloc]init];

    
}
- (void)findCollectionInfosWithType:(int)type{
    PFQuery *query = [PFQuery queryWithClassName:@"Collection"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"type" equalTo:[NSNumber numberWithInt:type]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSLog(@"查找小镇数据：%@",objects);
        self->collectionDataSource = objects;
        [self->mCollectTableView reloadData];
    }];
}
- (UIView *)cteateNavViewWithFrame:(CGRect)frame{
    UIView *navView = [[UIView alloc]initWithFrame:frame];
    townButton = [self createButtonWithFrame:CGRectMake(0, 0, 60, 45) :@"小镇" :@selector(townButtonPressed:)];
    [navView addSubview:townButton];
    categoryButton = [self createButtonWithFrame:CGRectMake(navView.frame.size.width - 60, 0, 60, 45) :@"攻略" :@selector(townButtonPressed:)];
    [navView addSubview:categoryButton];
    
    self.slideBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, 60, 3)];
    self.slideBarView.backgroundColor = [UIColor colorWithRed:139.0/255.0 green:195.0/255.0 blue:74.0/255.0 alpha:1];
    [navView addSubview:self.slideBarView];
    return navView;
}
#pragma mark - 事件处理
- (void)townButtonPressed:(id)sender{
    UIButton *pressButton = (UIButton *)sender;
    CGPoint center = CGPointMake(pressButton.center.x, self.slideBarView.center.y);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    self.slideBarView.center = center;
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    if ([pressButton.titleLabel.text isEqualToString:@"小镇"]) {
        [categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self findCollectionInfosWithType:0];
    }else{
        [townButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self findCollectionInfosWithType:1];
    }
}
- (void)showLoginViewControllerIfNeeded
{
    if (self.childViewControllers.count == 0) {
        LoginViewController *loginVC = [[LoginViewController alloc]initWithTag:0];
        loginVC.loginBlock = ^(BOOL success){
            if (success) {
                [self updateLoginInfo];
            }
        };
        loginVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - SafeAreaBottomHeight - 44);
        [self addChildViewController:loginVC];
        [self.view addSubview:loginVC.view];
        [loginVC didMoveToParentViewController:self];
    }
    
}
- (void)removeLoginViewController{
    LoginViewController *loginVC = self.childViewControllers[0];
    [loginVC willMoveToParentViewController:nil];
    [loginVC.view removeFromSuperview];
    [loginVC removeFromParentViewController];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return collectionDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CollectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"identify%ld",(long)indexPath.row]];
    if (cell == nil) {
        cell = [[CollectTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"identify%ld",(long)indexPath.row]];
    }
    PFObject *dictInfo = [collectionDataSource objectAtIndex:indexPath.row];
//    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:[dictInfo objectForKey:@"cover_link"]]];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:[dictInfo objectForKey:@"cover_link"]] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
    [cell.coverImageView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.coverImageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = cell.coverImageView.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.coverImageView.layer.mask = maskLayer;
    [cell setTitleFrameAndDescFrame:[dictInfo objectForKey:@"name"] :[dictInfo objectForKey:@"description"]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PFObject *dictInfo = [collectionDataSource objectAtIndex:indexPath.row];
    WebViewController *webInfo = [[WebViewController alloc]initWithURLString:[dictInfo objectForKey:@"link"]];
    [self.navigationController pushViewController:webInfo animated:YES];
//    webInfo.tabBarItem
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 10)];
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
