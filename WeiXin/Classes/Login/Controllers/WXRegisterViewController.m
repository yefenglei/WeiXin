//
//  RegisterViewController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/12.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXRegisterViewController.h"

@interface WXRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UITextField *pwdField;
@property (weak, nonatomic) IBOutlet UITextField *userField;

@end

@implementation WXRegisterViewController

- (IBAction)textChanged:(id)sender {
    // 设置注册按钮的可能状态
    BOOL enabled=(self.userField.text.length>0&&self.pwdField.text.length>0);
    self.registerBtn.enabled=enabled;
}

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)registerBtnClicked:(id)sender {
    [self.view endEditing:YES];
    
    // 判断用户输入的是否为手机号码
    if (![self.userField isTelphoneNum]) {
        [MBProgressHUD showError:@"请输入正确的手机号码" toView:self.view];
        return;
    }
    
    // 1.把用户注册的数据保存单例
    WXUserInfo *userInfo=[WXUserInfo sharedWXUserInfo];
    userInfo.registerUser=self.userField.text;
    userInfo.registerPwd=self.pwdField.text;
    
    // 2.调用WCXMPPTool的xmppUserRegister
    [WXXMPPTool sharedWXXMPPTool].registerOperation=YES;
    // 提示
    [MBProgressHUD showMessage:@"正在注册中....." toView:self.view];
    __weak typeof(self) selfVc=self;
    [[WXXMPPTool sharedWXXMPPTool] xmppUserRegister:^(XMPPResultType type) {
        [selfVc handleResultType:type];
    }];
}

-(void)handleResultType:(XMPPResultType)type{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view];
        switch (type) {
            case XMPPResultTypeRegisterSuccess:
                [MBProgressHUD showSuccess:@"注册成功" toView:self.view];
                // 回到上个控制器
                [self dismissViewControllerAnimated:YES completion:nil];
                if ([self.delegate respondsToSelector:@selector(registerViewControllerDidFinishRegister)]) {
                    [self.delegate registerViewControllerDidFinishRegister];
                }
                break;
            case XMPPResultTypeRegisterFailure:
                [MBProgressHUD showError:@"注册失败,用户名重复" toView:self.view];
                break;
            case XMPPResultTypeNetErr:
                [MBProgressHUD showError:@"注册失败,用户名重复" toView:self.view];
                break;
            default:
                break;
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置TextFeild的背景
    self.userField.background=[UIImage stretchedImageWithName:@"operationbox_text"];
    self.pwdField.background=[UIImage stretchedImageWithName:@"operationbox_text"];
    [self.registerBtn setResizeN_BG:@"fts_green_btn" H_BG:@"fts_green_btn_HL"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    FLLog(@"register controller had been released!");
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
