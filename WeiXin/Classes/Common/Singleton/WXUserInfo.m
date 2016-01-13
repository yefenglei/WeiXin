//
//  WXUserInfo.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/12.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXUserInfo.h"

#define UserKey @"user"
#define LoginStatusKey @"LoginStatus"
#define PwdKey @"pwd"

@implementation WXUserInfo

singleton_implementation(WXUserInfo)

///  从沙盒里获取用户数据
-(void)loadUserInfoFromSanbox{
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    self.user=[defaults objectForKey:UserKey];
    self.pwd=[defaults objectForKey:PwdKey];
    self.loginStatus=[defaults boolForKey:LoginStatusKey];
}
///  保存用户数据到沙盒
-(void)saveUserInfoToSanbox{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.user forKey:UserKey];
    [defaults setObject:self.pwd forKey:PwdKey];
    [defaults setBool:self.loginStatus forKey:LoginStatusKey];
    [defaults synchronize];
}

@end
