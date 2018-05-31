//
//  HGBNotificationViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/3/15.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBNotificationViewController.h"

#import "HGBNotificationTool.h"

#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"

@interface HGBNotificationViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBNotificationViewController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI

}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1]];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"原生消息工具";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;


    //左键
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回"  style:UIBarButtonItemStylePlain target:self action:@selector(returnhandler)];
    [self.navigationItem.leftBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UI
-(void)viewSetUp{
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,0, kWidth, kHeight) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.dataDictionary=@{@"通知":@[@"发送通知",@"监听通知",@"移除监听"],@"本地推送":@[@"发送本地推送",@"监听本地推送",@"取消本地推送"],@"远程推送":@[@"获取devicetoken",@"监听推送消息",@"监听devicetoken",@"停止远程推送",@"重启远程推送"]};
    self.keys=@[@"通知",@"本地推送",@"远程推送"];

    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];
}
#pragma mark table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72 * hScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 72 * hScale)];
    headView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    //信息提示栏
    UILabel *tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(32 * wScale, 0, kWidth - 32 * wScale, CGRectGetHeight(headView.frame))];
    tipMessageLabel.backgroundColor = [UIColor clearColor];
    tipMessageLabel.text =self.keys[section];
    tipMessageLabel.textColor = [UIColor grayColor];
    tipMessageLabel.textAlignment = NSTextAlignmentLeft;
    tipMessageLabel.font = [UIFont systemFontOfSize:12.0];
    tipMessageLabel.numberOfLines = 0;
    [headView addSubview:tipMessageLabel];
    return headView;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=self.keys[section];
    NSArray *dataAraay=[self.dataDictionary objectForKey:key];
    return  dataAraay.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGBCommonSelectCell *cell=[tableView dequeueReusableCellWithIdentifier:Identify_Cell forIndexPath:indexPath];
    NSString *key=self.keys[indexPath.section];
    NSArray *dataArray=[self.dataDictionary objectForKey:key];
    cell.title.text=dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        if (indexPath.row==0){
            [[HGBNotificationTool shareInstance]sendNotificationWithName:@"test" andWithUserInfo:@{@"name":@"huang"}];
        }else if (indexPath.row==1){
            [[HGBNotificationTool shareInstance] observerNotificationWithObserver:self selector:@selector(reviceNoti:) name:@"test"];

        }else if (indexPath.row==2){
            [[HGBNotificationTool shareInstance] removeNotificationObserver:self andWithName:@"test"];

        }

    }else if(indexPath.section==1){
        if (indexPath.row==0){

            NSDate *date1=[NSDate dateWithTimeIntervalSinceNow:10];
            NSDate *date2=[NSDate dateWithTimeIntervalSinceNow:20];
            NSDate *date3=[NSDate dateWithTimeIntervalSinceNow:30];
            [[HGBNotificationTool shareInstance]pushLocalNotificationWithMessageTitle:@"测试本地通知1" andWithMessageSubTitle:@"测试本地通知1" andWithMessageBody:@"测试本地通知1" andWithUserInfo:@{@"name":@"huang"} andWithMessageIdentify:@"1" InFireDate:date1 andWithReslutBlock:^(BOOL status, NSDictionary *returnMessage) {
                NSLog(@"%@",returnMessage);
            }];
            [[HGBNotificationTool shareInstance]pushLocalNotificationWithMessageTitle:@"测试本地通知2" andWithMessageSubTitle:@"测试本地通知2" andWithMessageBody:@"测试本地通知2" andWithUserInfo:@{@"name":@"huang"} andWithMessageIdentify:@"2" InFireDate:date2 andWithReslutBlock:^(BOOL status, NSDictionary *returnMessage) {
                NSLog(@"%@",returnMessage);
            }];
            [[HGBNotificationTool shareInstance]pushLocalNotificationWithMessageTitle:nil andWithMessageSubTitle:nil andWithMessageBody:nil andWithUserInfo:nil andWithMessageIdentify:@"3" InFireDate:date3 andWithReslutBlock:^(BOOL status, NSDictionary *returnMessage) {
                NSLog(@"%@",returnMessage);
            }];


        }else if (indexPath.row==1){
            [HGBNotificationTool shareInstance].messageBlock = ^(HGBNotificatonType type, NSDictionary *message) {
                NSLog(@"%@",message);
            };

        }else if (indexPath.row==2){
            [[HGBNotificationTool shareInstance]cancelLocalNotificationWithMessageIdentify:@"2"];

        }

    }else if(indexPath.section==2){
        if (indexPath.row==0){
            NSLog(@"devicetoken:%@",[[HGBNotificationTool shareInstance]getRemoteNotificationDeviceToken]);
        }else if (indexPath.row==1){
            [HGBNotificationTool shareInstance].messageBlock = ^(HGBNotificatonType type, NSDictionary *message) {
                NSLog(@"%@",message);
            };

        }else if (indexPath.row==2){
            [HGBNotificationTool shareInstance].deviceTokenBlock = ^(BOOL status, NSString *deviceToken) {
                NSLog(@"devicetoken:%@",deviceToken);
            };

        }else if (indexPath.row==3){
            [[HGBNotificationTool shareInstance]stopRemotePush];

        }else if (indexPath.row==4){
            [[HGBNotificationTool shareInstance]resumeRemotePush];
        }

    }
}
-(void)reviceNoti:(NSNotification *)noti{
    NSLog(@"reciveNoti:name=%@  userinfo=%@",noti.name,noti.userInfo);
}

#pragma mark get
-(NSDictionary *)dataDictionary{
    if(_dataDictionary==nil){
        _dataDictionary=[NSDictionary dictionary];
    }
    return _dataDictionary;
}
-(NSArray *)keys{
    if(_keys==nil){
        _keys=[NSArray array];
    }
    return _keys;
}

@end
