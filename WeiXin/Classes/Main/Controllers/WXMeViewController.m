//
//  WXMeViewController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/10.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXMeViewController.h"
#import "AppDelegate.h"

@interface WXMeViewController ()

@end

@implementation WXMeViewController

- (IBAction)logoutClicked:(id)sender {
    [[WXXMPPTool sharedWXXMPPTool] xmppUserLogout];
}

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
