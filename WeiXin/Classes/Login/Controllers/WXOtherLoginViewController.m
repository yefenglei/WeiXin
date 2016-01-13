//
//  WXOtherLoginViewController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/7.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXOtherLoginViewController.h"
#import "AppDelegate.h"


@interface WXOtherLoginViewController ()
- (IBAction)cancelClicked:(UIBarButtonItem *)sender;
- (IBAction)loginClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *userField;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;

@end

@implementation WXOtherLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 根据设备，设置登录框两边的宽度
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        self.leftConstraint.constant=10;
        self.rightConstraint.constant=10;
    }
    // 设置文本框背景图片
    self.userField.background=[UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background= [UIImage stretchedImageWithName:@"operationbox_text"];
    
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}

- (IBAction)cancelClicked:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginClicked:(UIButton *)sender{
    // 登录
    
    /*
     * 官方的登录实现
     
     * 1.把用户名和密码放在沙盒
     
     
     * 2.调用 AppDelegate的一个login 连接服务并登录
     */
    WXUserInfo *userInfo= [WXUserInfo sharedWXUserInfo];
    userInfo.user=self.userField.text;
    userInfo.pwd=self.pwdField.text;
    
    [super login];
    
}

- (void)dealloc
{
    FLLog(@"%s",__func__);
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
