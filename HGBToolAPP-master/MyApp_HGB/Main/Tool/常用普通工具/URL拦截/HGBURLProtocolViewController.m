

//
//  HGBURLProtocolViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/2/8.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBURLProtocolViewController.h"
#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"

#import "HGBURLProtocol.h"


@interface HGBURLProtocolViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBURLProtocolViewController

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
    titleLab.text=@"URL拦截";
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
    self.dataDictionary=@{@"URL拦截":@[@"URL拦截黑名单设置",@"URL拦截白名单设置",@"清空",@"发起白名单请求",@"发起白名单以外请求",@"发起黑名单请求",@"发起黑名单以外请求"]};
    self.keys=@[@"URL拦截"];

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

            [HGBURLProtocol setBlackListArray:@[@"https://itunes.apple.com"]];

        }else if (indexPath.row==1){
            [HGBURLProtocol setWhiteListArray:@[@"https://itunes.apple.com"]];

        }else if (indexPath.row==2){
            [HGBURLProtocol setWhiteListArray:@[]];
            [HGBURLProtocol setBlackListArray:@[]];

        }else if (indexPath.row==3){
            NSString *urlStr=[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=1042178917"];
            NSURL *url=[NSURL URLWithString:urlStr];
            //会话
            NSURLSession *session=[NSURLSession sharedSession];
            NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error){

                    NSLog(@"error:%@",error);
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"response:%@",str);
                }

            }];
            //启动任务
            [task resume];


        }else if (indexPath.row==4){
            NSString *urlStr=[NSString stringWithFormat:@"http://61.149.7.23:6982/financialmngr/queryriskevaluation?productID=001&certType=01&certNo=001"];
            NSURL *url=[NSURL URLWithString:urlStr];
            //会话
            NSURLSession *session=[NSURLSession sharedSession];
            NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error){

                    NSLog(@"error:%@",error);
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"response:%@",str);
                }

            }];
            //启动任务
            [task resume];


        }else if (indexPath.row==5){
            NSString *urlStr=[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=1042178917"];
            NSURL *url=[NSURL URLWithString:urlStr];
            //会话
            NSURLSession *session=[NSURLSession sharedSession];
            NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error){

                    NSLog(@"error:%@",error);
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"response:%@",str);
                }

            }];
            //启动任务
            [task resume];

        }else if (indexPath.row==6){
            NSString *urlStr=[NSString stringWithFormat:@"http://61.149.7.23:6982/financialmngr/queryriskevaluation?productID=001&certType=01&certNo=001"];
            NSURL *url=[NSURL URLWithString:urlStr];
            //会话
            NSURLSession *session=[NSURLSession sharedSession];
            NSURLSessionDataTask *task=[session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if(error){

                    NSLog(@"error:%@",error);
                }else{
                    NSString *str=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"response:%@",str);
                }

            }];
            //启动任务
            [task resume];
        }



    }
}
-(void)presentController:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
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
