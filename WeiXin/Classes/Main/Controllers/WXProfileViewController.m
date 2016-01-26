//
//  WXProfileViewController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/25.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXProfileViewController.h"
#import "XMPPvCardTemp.h"
#import "WXEditProfileViewController.h"

@interface WXProfileViewController ()<WXEditProgileViewControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;//昵称
@property (weak, nonatomic) IBOutlet UIImageView *headerView;//头像

@property (weak, nonatomic) IBOutlet UILabel *weixinNumLabel;//微信号
@property (weak, nonatomic) IBOutlet UILabel *orgnameLabel;//公司
@property (weak, nonatomic) IBOutlet UILabel *orgunitLabel;//部门
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//职位
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;//电话
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;//邮件

@end

@implementation WXProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"个人信息";
    [self loadVCard];
}

///  加载电子名片信息
-(void)loadVCard{
    //显示人个信息
    
    //xmpp提供了一个方法，直接获取个人信息
    XMPPvCardTemp *myVCard=[WXXMPPTool sharedWXXMPPTool].vCard.myvCardTemp;
    
    // 设置头像
    if(myVCard.photo){
        self.headerView.image=[UIImage imageWithData:myVCard.photo];
    }
    
    // 设置昵称
    self.nicknameLabel.text=myVCard.nickname;
    
    // 设置微信号[用户名]
    self.weixinNumLabel.text=[WXUserInfo sharedWXUserInfo].user;
    
    // 公司
    self.orgnameLabel.text=myVCard.orgName;
    
    // 部门
    if(myVCard.orgUnits.count>0){
        self.orgunitLabel.text=myVCard.orgUnits[0];
    }
    
    //职位
    self.titleLabel.text=myVCard.title;
    
    //电话
#warning myVCard.telecomsAddresses 这个get方法，没有对电子名片的xml数据进行解析
    // 使用note字段充当电话
    self.phoneLabel.text = myVCard.note;
    
    //邮件
    // 用mailer充当邮件
    self.emailLabel.text = myVCard.mailer;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取cell.tag
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    NSInteger tag=cell.tag;
    
    // 判断
    if(tag == 2){
        // 不做任何操作
        FLLog(@"tag ＝＝ 2 不做任何操作");
        return;
    }
    
    if(tag ==0){
        // 选择照片
        FLLog(@"选择照片");
//        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"照相" otherButtonTitles:@"相册", nil];
//        [sheet showInView:self.view];
        
        UIAlertController *alertVC=[UIAlertController alertControllerWithTitle:@"请选择" message:@"选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *actionCancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            FLLog(@"用户取消了选择照片");
        }];
        UIAlertAction *actionTakePhoto=[UIAlertAction actionWithTitle:@"照相" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            FLLog(@"用户选择了照相");
            [self openImagePicker:0];
        }];
        UIAlertAction *actionPhotos=[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            FLLog(@"用户选择了相册");
            [self openImagePicker:1];
        }];
        [alertVC addAction:actionCancel];
        [alertVC addAction:actionTakePhoto];
        [alertVC addAction:actionPhotos];
        alertVC.modalPresentationStyle=UIModalPresentationPopover;
        alertVC.popoverPresentationController.sourceView=self.headerView;
        alertVC.popoverPresentationController.sourceRect=self.headerView.bounds;
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }else{
        // 跳到下一个控制器
        FLLog(@"调到下一个控制器");
        [self performSegueWithIdentifier:@"EditVCardSegue" sender:cell];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //获取编辑个人信息的控制
    id destVc=segue.destinationViewController;
    if([destVc isKindOfClass:[WXEditProfileViewController class]]){
        WXEditProfileViewController *editVc=destVc;
        editVc.cell=sender;
        editVc.delegate=self;
    }
}

#pragma mark - actionsheet的代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self openImagePicker:buttonIndex];
}

///  打开相机或者相册
///
///  @param buttonIndex 2表示取消，1表示相册，0表示照相
-(void)openImagePicker:(NSInteger)buttonIndex{
    if (buttonIndex == 2) {
        // 取消
        return;
    }
    
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    // 设置代理
    imagePicker.delegate=self;
    
    // 设置允许编辑
    imagePicker.allowsEditing=YES;
    
    if(buttonIndex==0){
        // 照相
        imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
    }else{
        // 相册
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // 显示图片选择器
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark 图片选择器的代理
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    FLLog(@"%@",info);
    // 获取图片 设置图片
    UIImage *image=info[UIImagePickerControllerEditedImage];
    
    self.headerView.image=image;
    
    // 隐藏当前模态窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 更新到服务器
    [self editProfileViewControllerDidSave];
}

#pragma mark 编辑个人信息的控制器代理
-(void)editProfileViewControllerDidSave{
    // 保存
    // 获取当前的电子名片信息
    XMPPvCardTemp *myvCard=[WXXMPPTool sharedWXXMPPTool].vCard.myvCardTemp;
    
    // 图片
    myvCard.photo=UIImagePNGRepresentation(self.headerView.image);
    
    // 昵称
    myvCard.nickname=self.nicknameLabel.text;
    
    // 公司
    myvCard.orgName=self.orgnameLabel.text;
    
    // 部门
    if(self.orgunitLabel.text.length>0){
        myvCard.orgUnits=@[self.orgunitLabel.text];
    }
    
    // 职位
    myvCard.title=self.titleLabel.text;
    
    // 电话
    myvCard.note=self.phoneLabel.text;
    
    // 邮件
    myvCard.mailer=self.emailLabel.text;
    
    // 更新 这个方法内部会实现数据上传到服务，无需程序自己操作
    [[WXXMPPTool sharedWXXMPPTool].vCard updateMyvCardTemp:myvCard];
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
