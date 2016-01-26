//
//  WXAddContactViewController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/26.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXAddContactViewController.h"

@interface WXAddContactViewController ()<UITextFieldDelegate>

@end

@implementation WXAddContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    // 添加好友
    
    // 1.获取好友账号
    NSString *user=textField.text;
    
    // 判断这个账号是否为手机号码
    if(![textField isTelphoneNum]){
        // 提示
        [self showAlert:@"请输入正确的手机号码"];
        return YES;
    }
    
    // 判断是否添加自己
    if([user isEqualToString:[WXUserInfo sharedWXUserInfo].user]){
        [self showAlert:@"不能添加自己为联系人"];
        return YES;
    }
    
    NSString *jidStr=[NSString stringWithFormat:@"%@@%@",user,domain];
    XMPPJID *friendJid=[XMPPJID jidWithString:jidStr];
    
    // 判断好友是否已经存在
    if([[WXXMPPTool sharedWXXMPPTool].rosterStorage userExistsWithJID:friendJid xmppStream:[WXXMPPTool sharedWXXMPPTool].xmppStream]){
        [self showAlert:@"当前好友已经存在"];
        return YES;
    }
    
    // 2.发送好友添加的请求
    // 添加好友,xmpp有个叫订阅
    [[WXXMPPTool sharedWXXMPPTool].roster subscribePresenceToUser:friendJid];
    return YES;
}

-(void)showAlert:(NSString*)msg{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:msg delegate:nil cancelButtonTitle:@"谢谢" otherButtonTitles:nil, nil];
    [alert show];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
