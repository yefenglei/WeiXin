//
//  AppDelegate.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/6.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "AppDelegate.h"
#import "XMPPFramework.h"
#import "WXNavigationController.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 打开XMPP的日志
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // 设置导航栏背景
    [WXNavigationController setupNavTheme];
    
    // 从沙盒加载用户的数据到单例
    [[WXUserInfo sharedWXUserInfo] loadUserInfoFromSanbox];
    
    // 判断用户的登录状态，YES 直接来到主界面
    if ([WXUserInfo sharedWXUserInfo].loginStatus) {
        UIStoryboard *storyboard= [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        self.window.rootViewController=storyboard.instantiateInitialViewController;
        
        // 自动登录服务
        [[WXXMPPTool sharedWXXMPPTool] xmppUserLogin:nil];
        
    }
    return YES;
}

@end