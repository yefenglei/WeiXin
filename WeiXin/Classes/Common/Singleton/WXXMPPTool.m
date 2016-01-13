//
//  WXXMPPTool.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/12.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXXMPPTool.h"

/*
 * 在AppDelegate实现登录
 
 1. 初始化XMPPStream
 2. 连接到服务器[传一个JID]
 3. 连接到服务成功后，再发送密码授权
 4. 授权成功后，发送"在线" 消息
 */
@interface WXXMPPTool()<XMPPStreamDelegate>{
    XMPPStream *_xmppStream;
    XMPPResultBlock _resultBlock;
}

// 1. 初始化XMPPStream
-(void)setupXMPPStream;


// 2.连接到服务器
-(void)connectToHost;

// 3.连接到服务成功后，再发送密码授权
-(void)sendPwdToHost;


// 4.授权成功后，发送"在线" 消息
-(void)sendOnlineToHost;

@end

@implementation WXXMPPTool

singleton_implementation(WXXMPPTool)

#pragma mark  -私有方法
#pragma mark 初始化XMPPStream
-(void)setupXMPPStream{
    
    _xmppStream = [[XMPPStream alloc] init];
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark 连接到服务器
-(void)connectToHost{
    FLLog(@"开始连接到服务器");
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
    
    // 设置登录用户JID
    //resource 标识用户登录的客户端 iphone android
    
    // 从单例获取用户名
    NSString *user=nil;
    if(self.isRegisterOperation){
        user=[WXUserInfo sharedWXUserInfo].registerUser;
    }else{
        user=[WXUserInfo sharedWXUserInfo].user;
    }
    
    XMPPJID *myJID = [XMPPJID jidWithUser:user domain:@"yefenglei.local" resource:@"iphone" ];
    _xmppStream.myJID = myJID;
    
    // 设置服务器域名
    _xmppStream.hostName = @"yefenglei.local";//不仅可以是域名，还可是IP地址
    
    // 设置端口 如果服务器端口是5222，可以省略
    _xmppStream.hostPort = 5222;
    
    // 连接
    NSError *err = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]){
        FLLog(@"%@",err);
    }
    
}


#pragma mark 连接到服务成功后，再发送密码授权
-(void)sendPwdToHost{
    FLLog(@"再发送密码授权");
    NSError *err = nil;
    // 从单例里获取密码
    NSString *pwd=[WXUserInfo sharedWXUserInfo].pwd;
    [_xmppStream authenticateWithPassword:pwd error:&err];
    if (err) {
        FLLog(@"%@",err);
    }
}

#pragma mark  授权成功后，发送"在线" 消息
-(void)sendOnlineToHost{
    
    FLLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    FLLog(@"%@",presence);
    
    [_xmppStream sendElement:presence];
    
    
}
#pragma mark -XMPPStream的代理
#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    FLLog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {
        NSString *pwd=[WXUserInfo sharedWXUserInfo].registerPwd;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{
        // 登录操作
        // 主机连接成功后，发送密码进行授权
        [self sendPwdToHost];
    }
    
    // 主机连接成功后，发送密码进行授权
    [self sendPwdToHost];
}
#pragma mark  与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    
    if(error && _resultBlock){
        _resultBlock(XMPPResultTypeNetErr);
    }
    
    FLLog(@"与主机断开连接 %@",error);
    
}


#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    FLLog(@"授权成功");
    
    [self sendOnlineToHost];
    
    // 回调控制器登录成功
    if(_resultBlock){
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
}


#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    // 判断block有无值，再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
    FLLog(@"授权失败 %@",error);
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    FLLog(@"注册成功");
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    FLLog(@"注册失败 %@",error);
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
}


#pragma mark -公共方法
-(void)xmppUserLogout{
    // 1." 发送 "离线" 消息"
    XMPPPresence *offline = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:offline];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
    
    // 3. 回到登录界面
    [UIStoryboard showInitialVCWithName:@"Login"];
    
    // 4. 更新用户的登录状态
    [WXUserInfo sharedWXUserInfo].loginStatus=NO;
    [[WXUserInfo sharedWXUserInfo] saveUserInfoToSanbox];
    
}

-(void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    // 先把block保存起来
    _resultBlock=resultBlock;
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    // 连接主机 成功后发送密码
    [self connectToHost];
}

-(void)xmppUserRegister:(XMPPResultBlock)resultBlock{
    // 先把block存起来
    _resultBlock = resultBlock;
    
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    // 连接主机 成功后发送注册密码
    [self connectToHost];
}

@end
