//
//  WXMeViewController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/10.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXMeViewController.h"
#import "AppDelegate.h"
#import "XMPPvCardTemp.h"

@interface WXMeViewController ()

/**
 *  头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerView;
/**
 *  昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;

/**
 *  微信号
 */
@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;

@end

@implementation WXMeViewController

- (IBAction)logoutClicked:(id)sender {
    [[WXXMPPTool sharedWXXMPPTool] xmppUserLogout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 显示当前用户个人信息
    
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard=[WXXMPPTool sharedWXXMPPTool].vCard.myvCardTemp;
    
    // 设置头像
    if(myVCard.photo){
        self.headerView.image=[UIImage imageWithData:myVCard.photo];
    }
    
    // 设置昵称
    self.nickNameLabel.text=myVCard.nickname;
    
    // 设置微信号【用户名】
    NSString *user=[WXUserInfo sharedWXUserInfo].user;
    self.weixinNumLabel.text=[NSString stringWithFormat:@"微信号%@",user];
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
