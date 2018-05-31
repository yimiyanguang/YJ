//
//  HGBAudioViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/1/29.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBAudioViewController.h"
#import "HGBCommonSelectCell.h"
#import "HGBAudioTool.h"
#define Identify_Cell @"cell"
#import "HGBAudioPlayer.h"
#import "HGBAudioRecorder.h"

@interface HGBAudioViewController ()<HGBAudioToolDelegate,HGBAudioPlayerDelegate,HGBAudioRecorderDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBAudioViewController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI
    [HGBAudioTool shareInstance].delegate=self;

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
    titleLab.text=@"音频";
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
    self.dataDictionary=@{@"音频工具":@[@"开始录音",@"暂停录音",@"停止录音",@"取消录音",@"播放器工具",@"录音器",@"音频剪切",@"音频合成",@"音频压缩"]};
    self.keys=@[@"音频工具"];

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
            [[HGBAudioTool shareInstance] startRecording];
        }else if (indexPath.row==1){
            [[HGBAudioTool shareInstance] parseRecording];
        }else if (indexPath.row==2){
            [[HGBAudioTool shareInstance] stopRecording];
        }else if (indexPath.row==3){
            [[HGBAudioTool shareInstance] cancelRecording];
        }else if (indexPath.row==4){
            HGBAudioPlayer *player=[[HGBAudioPlayer alloc]init];

            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:player];
            [self presentViewController:nav animated:YES completion:nil];
             player.url=@"project://test.aac";
        }else if (indexPath.row==5){
            HGBAudioRecorder *player=[[HGBAudioRecorder alloc]init];

            UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:player];
            [self presentViewController:nav animated:YES completion:nil];
            player.url=@"document://test.m4a";
        }else if (indexPath.row==6){
            [[HGBAudioTool shareInstance] cutAudioWithSource:@"project://test.aac" andWithStartTime:9 andWithEndTime:20 toDestination:@"document://hai.m4a"];
        }else if (indexPath.row==7){
            [[HGBAudioTool shareInstance] makeupAudioWithSource:@"project://test.aac" andWithOtherSource:@"project://test2.aac" toDestination:@"document://test.m4a"];
        }
    }
}
#pragma mark audioTool-delegate
-(void)audioTool:(HGBAudioTool *)audio didFailedWithError:(NSDictionary *)errorInfo{
    NSLog(@"error:%@",errorInfo);
}
-(void)audioToolDidCanceled:(HGBAudioTool *)audio{
    NSLog(@"cancel");
}
-(void)audioToolDidSucessed:(HGBAudioTool *)audio{
    NSLog(@"sucess");
}
-(void)audioTool:(HGBAudioTool *)audio didSucessedWithPath:(NSString *)path{
    NSLog(@"%@",path);
}
#pragma mark audioPlayer-delegate
-(void)audioPlayer:(HGBAudioPlayer *)player didFailedWithError:(NSDictionary *)errorInfo{
     NSLog(@"error:%@",errorInfo);
}
-(void)audioPlayerDidCanceled:(HGBAudioPlayer *)player{
    NSLog(@"cancel");
}
-(void)audioPlayerDidSucessed:(HGBAudioPlayer *)player{
     NSLog(@"sucess");
}
#pragma mark audioRecorder-delegate
-(void)audioRecorder:(HGBAudioRecorder *)recorder didSucessedWithPath:(NSString *)path{
    NSLog(@"%@",path);
}
-(void)audioRecorderDidSucessed:(HGBAudioRecorder *)recorder{
    NSLog(@"sucess");
}
-(void)audioRecorderDidCanceled:(HGBAudioRecorder *)recorder{
    NSLog(@"cancel");
}
-(void)audioRecorder:(HGBAudioRecorder *)recorder didFailedWithError:(NSDictionary *)errorInfo{
    NSLog(@"error:%@",errorInfo);
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
