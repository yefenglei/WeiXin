//
//  WXLoginViewController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/12.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXLoginViewController.h"
#import "WXNavigationController.h"
#import "WXRegisterViewController.h"

@interface WXLoginViewController ()<WXRegisterViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation WXLoginViewController

- (IBAction)loginBtnClicked:(id)sender {
    // 保存数据到单例
    WXUserInfo *userInfo=[WXUserInfo sharedWXUserInfo];
    userInfo.user=self.userLabel.text;
    userInfo.pwd=self.pwdField.text;
    
    // 调用父类的登录
    [super login];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // 获取注册控制器
    id destVc=segue.destinationViewController;
    if([destVc isKindOfClass:[WXNavigationController class]]){
        WXNavigationController *nav=destVc;
        //获取根控制器
        WXRegisterViewController *registerVc=(WXRegisterViewController *)nav.topViewController;
        // 设置注册控制器的代理
        registerVc.delegate = self;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置TextField和Btn的样式
    self.pwdField.background=[UIImage stretchedImageWithName:@"operationbox_text"];
    [self.pwdField addLeftViewWithImage:@"Card_Lock"];
    [self.loginBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
    
    // 设置用户名为上次登录的用户名
    //从沙盒获取用户名
    NSString *user=[WXUserInfo sharedWXUserInfo].user;
    self.userLabel.text=user;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark registerViewController的代理
-(void)registerViewControllerDidFinishRegister{
    FLLog(@"完成注册");
    // 完成注册 userLabel显示注册的用户名
    self.userLabel.text=[WXUserInfo sharedWXUserInfo].registerUser;
    // 提示
    [MBProgressHUD showSuccess:@"请重新输入密码进行登录" toView:self.view];
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
