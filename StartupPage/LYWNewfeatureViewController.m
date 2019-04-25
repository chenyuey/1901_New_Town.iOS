//
//  LYWNewfeatureViewController.m
//  NewTown
//
//  Created by macbookpro on 2019/4/24.
//  Copyright © 2019年 macbookpro. All rights reserved.
//

#import "LYWNewfeatureViewController.h"

#define NewfeatureCount 1
@interface LYWNewfeatureViewController ()<UIScrollViewDelegate>
@property (nonatomic,weak) UIPageControl *pageControl;
@end

@implementation LYWNewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupScrollView];
}

//创建UIScrollView并添加图片
- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:scrollView];
    
    scrollView.bounces = NO;
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.contentSize = CGSizeMake(NewfeatureCount*SCREEN_WIDTH, 0);
    scrollView.delegate = self;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Advertisement"];
    
    [query whereKey:@"isOnline" equalTo:[NSNumber numberWithBool:true]];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    CGFloat scale = SCREEN_WIDTH / 375.0;
    UIImage *bgImage = [UIImage scaleImage:[UIImage imageNamed:@"start_up"] toScale:scale];
    UIImage *cutImage = [UIImage ct_imageFromImage:bgImage inRect:CGRectMake(0, bgImage.size.height - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image = cutImage;
    [scrollView addSubview:imageView];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable result, NSError * _Nullable error) {
        if (error == nil &&  result.count > 0) {
            PFFileObject *userImageFile = [[result objectAtIndex:0]objectForKey:@"adImage"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error) {
                    CGFloat scale = SCREEN_WIDTH / 375.0;
                    UIImage *image = [UIImage imageWithData:imageData];
                    UIImage *bgImage = [UIImage scaleImage:image toScale:scale];
                    UIImage *cutImage = [UIImage ct_imageFromImage:bgImage inRect:CGRectMake(0, bgImage.size.height - SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
                    imageView.image = cutImage;
                    [scrollView addSubview:imageView];
                }
            }];
        }
    }];
    
    
    
    
    
    [self performSelector:@selector(jumpToIndexViewController) withObject:nil afterDelay:2.0];
}

//左上角的灰色跳过按钮
-(void)createSkipBt
{
    UIButton *skipBt = [UIButton buttonWithType:UIButtonTypeCustom];
    skipBt.frame = CGRectMake(SCREEN_WIDTH - 90, 40, 80, 30);
    skipBt.backgroundColor = [UIColor colorWithRed:0.3 green:0.3f blue:0.3f alpha:0.3];
    [skipBt setTitle:@"跳过" forState:UIControlStateNormal];
    [skipBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    skipBt.layer.cornerRadius = 10;
    skipBt.clipsToBounds = YES;
    skipBt.tag = 10;
    [skipBt addTarget:self action:@selector(BtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:skipBt];
}

//手动拖拽结束时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    double page = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 四舍五入计算出页码
//    self.pageControl.currentPage = (int)(page + 0.5);
}

//给最后一张图片添加 进入问医生按钮
- (void)setupStartBtn:(UIImageView *)imgView
{
    imgView.userInteractionEnabled = YES;
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    [btn setBackgroundImage:[UIImage imageNamed:@"enter_home"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, btn.currentBackgroundImage.size.width, btn.currentBackgroundImage.size.height);
    btn.center = CGPointMake(imgView.frame.size.width * 0.5, imgView.frame.size.height * 0.75);
    [btn setTitle:@"进入问医生" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(BtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [imgView addSubview:btn];
}

//进入问医生按钮点击事件
-(void)jumpToIndexViewController
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    window.rootViewController = delegate.tabBarC;
//    window.rootViewController = [[LYWTabBarViewController alloc] init];
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
