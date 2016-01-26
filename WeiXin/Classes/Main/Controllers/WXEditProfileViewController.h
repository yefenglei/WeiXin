//
//  WXEditProfileViewController.h
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/25.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WXEditProgileViewControllerDelegate <NSObject>;

-(void)editProfileViewControllerDidSave;

@end

@interface WXEditProfileViewController : UITableViewController

@property (nonatomic,strong)UITableViewCell *cell;

@property (nonatomic,weak) id<WXEditProgileViewControllerDelegate> delegate;

@end
