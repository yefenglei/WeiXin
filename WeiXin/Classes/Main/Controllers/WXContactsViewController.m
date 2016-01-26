//
//  WXContactsViewController.m
//  WeiXin
//
//  Created by 叶锋雷 on 16/1/26.
//  Copyright © 2016年 叶锋雷. All rights reserved.
//

#import "WXContactsViewController.h"

@interface WXContactsViewController ()<NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_resultsControl;
}

@property (nonatomic,strong) NSArray *friends;

@end

@implementation WXContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadFriends2];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadFriends{
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context=[WXXMPPTool sharedWXXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    // 过滤当前登录用户的好友
    NSString *jid=[WXUserInfo sharedWXUserInfo].jid;
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate=pre;
    // 排序
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors=@[sort];
    
    // 4.执行请求获取数据
    self.friends=[context executeFetchRequest:request error:nil];
}

///  利用XMPP自带的NSFetchedResultsController加载好友数据，并对数据变化进行监听
-(void)loadFriends2{
    //使用CoreData获取数据
    // 1.上下文【关联到数据库XMPPRoster.sqlite】
    NSManagedObjectContext *context=[WXXMPPTool sharedWXXMPPTool].rosterStorage.mainThreadManagedObjectContext;
    
    // 2.FetchRequest【查哪张表】
    NSFetchRequest *request=[NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    // 3.设置过滤和排序
    // 过滤当前登录用户的好友
    NSString *jid=[WXUserInfo sharedWXUserInfo].jid;
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"streamBareJidStr = %@",jid];
    request.predicate=pre;
    
    // 排序
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    request.sortDescriptors=@[sort];
    
    // 4.执行请求获取数据
    _resultsControl=[[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultsControl.delegate=self;
    
    NSError *err=nil;
    [_resultsControl performFetch:&err];
    if(err){
        FLLog(@"%@",err);
    }
    
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    FLLog(@"好友数据发生变化");
    // 刷新表格
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _resultsControl.fetchedObjects.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"ContactCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];

    // 获取对应好友
    //XMPPUserCoreDataStorageObject *friend =self.friends[indexPath.row];
    XMPPUserCoreDataStorageObject *friend=_resultsControl.fetchedObjects[indexPath.row];
    //    sectionNum
    //    “0”- 在线
    //    “1”- 离开
    //    “2”- 离线
    switch ([friend.sectionNum intValue]) {
        case 0:
            cell.detailTextLabel.text=@"在线";
            break;
        case 1:
            cell.detailTextLabel.text=@"离开";
            break;
        case 2:
            cell.detailTextLabel.text=@"离线";
            break;
        default:
            break;
    }
    cell.textLabel.text=friend.jidStr;
    return cell;
}

///  左滑删除好友
///
///  @param tableView    <#tableView description#>
///  @param editingStyle <#editingStyle description#>
///  @param indexPath    <#indexPath description#>
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FLLog(@"删除好友");
        XMPPUserCoreDataStorageObject *friend=_resultsControl.fetchedObjects[indexPath.row];
        XMPPJID *friendJid=friend.jid;
        [[WXXMPPTool sharedWXXMPPTool].roster removeUser:friendJid];
    }
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
