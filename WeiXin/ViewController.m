//
//  ViewController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/6.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // 注销
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app logout];
}

@end
