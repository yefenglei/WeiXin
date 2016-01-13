//
//  RegisterViewController.h
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/12.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXRegisterViewControllerDelegate <NSObject>

-(void)registerViewControllerDidFinishRegister;

@end

@interface WXRegisterViewController : UIViewController

@property (nonatomic,weak) id<WXRegisterViewControllerDelegate> delegate;

@end
