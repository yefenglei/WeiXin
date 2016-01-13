//
//  WXXMPPTool.h
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/12.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XMPPFramework.h"

typedef enum {
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

/// XMPP请求结果的block
typedef void (^XMPPResultBlock)(XMPPResultType type);

@interface WXXMPPTool : NSObject

singleton_interface(WXXMPPTool)

///  用户登录
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock;
///  用户注销
-(void)xmppUserLogout;
///  用户注册
///
///  @param resultBlock 注册回调block
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock;

///  注册标识 YES 注册 / NO 登录
@property (nonatomic,assign,getter=isRegisterOperation) BOOL registerOperation;

@end
