//
//  WXNavigationController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/10.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXNavigationController.h"

@interface WXNavigationController ()

@end

@implementation WXNavigationController

///  设置导航栏的主题
+(void)setupNavTheme{
    // 设置导航栏样式
    UINavigationBar *navBar=[UINavigationBar appearance];
    
    // 1.设置导航条的背景
    // 高度不会拉伸，但是宽度会拉伸
    [navBar setBackgroundImage:[UIImage imageNamed:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    
    // 2.设置导航栏的字体
    NSMutableDictionary *attr=[NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName]=[UIColor whiteColor];
    attr[NSFontAttributeName]=[UIFont systemFontOfSize:20];
    
    [navBar setTitleTextAttributes:attr];
    
    // 设置状态栏的样式
    // xcode5以上，创建的项目，默认的话，这个状态栏的样式由控制器决定
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}

////结果，如果控制器是由导航控制管理，设置状态栏的样式时，要在导航控制器里设置
//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
