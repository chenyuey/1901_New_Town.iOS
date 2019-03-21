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
- (UIButton *)createButtonWithImage:(CGRect)frame :(NSString *)imageName :(SEL)pressEvent{
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    UIImage *image = [UIImage imageNamed:imageName];
    [image setAccessibilityIdentifier:@"uncollect"];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:pressEvent forControlEvents:UIControlEventTouchUpInside];
    return button;
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
    
    mCollectTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 17 + 48, SCREEN_WIDTH, contentView.frame.size.height - 7 - 48) style:UITableViewStylePlain];
    mCollectTableView.dataSource = self;
    mCollectTableView.delegate = self;
    mCollectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [contentView addSubview:mCollectTableView];
    
    NSDictionary *dictTmpInfo = @{@"title":@"黄山店",
                                  @"imgUrl":@"https://img.yzcdn.cn/upload_files/2019/03/14/FpDBi7GG27pJGrSxa9MgLz6TcVxQ.png?imageView2%2F2%2Fw%2F730%2Fh%2F0%2Fq%2F75%2Fformat%2Fpng",
                                  @"link":@"https://shop7188993.youzan.com/wscshop/showcase/feature?alias=xQT8Rjhbxw&banner_id=f.6996825~top2end~1~RTzTdR4v&reft=1553169529671&spm=f.78280629",
                                  @"desc":@"北京 房山"
                                  };
    collectionDataSource = [[NSArray alloc]initWithObjects:dictTmpInfo, nil];
}
- (UIView *)cteateNavViewWithFrame:(CGRect)frame{
    UIView *navView = [[UIView alloc]initWithFrame:frame];
    UIButton *townButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 45)];
    [townButton setTitle:@"小镇" forState:UIControlStateNormal];
    [townButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [townButton addTarget:self action:@selector(townButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:townButton];
    UIButton *categoryButton = [[UIButton alloc]initWithFrame:CGRectMake(navView.frame.size.width - 60, 0, 60, 45)];
    [categoryButton setTitle:@"攻略" forState:UIControlStateNormal];
    [categoryButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [categoryButton addTarget:self action:@selector(townButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:categoryButton];
    
    self.slideBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, 60, 3)];
    self.slideBarView.backgroundColor = [UIColor greenColor];
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
    NSDictionary *dictInfo = [collectionDataSource objectAtIndex:indexPath.row];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:[dictInfo objectForKey:@"imgUrl"]]];
    [cell.coverImageView layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:cell.coverImageView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = cell.coverImageView.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.coverImageView.layer.mask = maskLayer;
    
    cell.titleLabel.text = [dictInfo objectForKey:@"title"];
    cell.descLabel.text = [dictInfo objectForKey:@"desc"];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 112;
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
