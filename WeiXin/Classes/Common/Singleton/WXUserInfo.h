//
//  WXUserInfo.h
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/12.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface WXUserInfo : NSObject

singleton_interface(WXUserInfo);

@property (nonatomic,copy) NSString *user;// 用户名
@property (nonatomic,copy) NSString *pwd;// 密码
///  登录的状态 YES 登录过/NO 注销
@property (nonatomic,assign)BOOL loginStatus;
@property (nonatomic,copy) NSString *registerUser;//注册的用户名
@property (nonatomic,copy) NSString *registerPwd;//注册的密码
///  从沙盒里获取用户数据
-(void)loadUserInfoFromSanbox;
///  保存用户数据到沙盒
-(void)saveUserInfoToSanbox;

@end
