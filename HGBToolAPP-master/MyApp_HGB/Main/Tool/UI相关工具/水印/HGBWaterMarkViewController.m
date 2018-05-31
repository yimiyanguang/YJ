//
//  HGBWaterMarkViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/3/16.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBWaterMarkViewController.h"

#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"

#import "HGBWaterMarkTool.h"

@interface HGBWaterMarkViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
/**
 图片容器
 */
@property(strong,nonatomic)UIImageView *imageView;
/**
 原图片容器
 */
@property(strong,nonatomic)UIImageView *originimageView;
@end

@implementation HGBWaterMarkViewController

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
    titleLab.text=@"水印工具";
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
    self.dataDictionary=@{@"水印工具:":@[@"图片加图片水印",@"图片加文字水印",@"视频加图片水印",@"视频加文字水印"]};

    self.keys=@[@"水印工具:"];

    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];


    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    headerView.backgroundColor=[UIColor lightGrayColor];
    self.tableView.tableFooterView=headerView;


    self.originimageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 160, 160)];
    self.originimageView.backgroundColor=[UIColor yellowColor];
    self.originimageView.image=[UIImage imageNamed:@"test"];
    [headerView addSubview:self.originimageView];


    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(200, 20, 160, 160)];
    self.imageView.backgroundColor=[UIColor yellowColor];
    [headerView addSubview:self.imageView];


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
    NSLog(@"%f-%f",self.originimageView.image.size.width,self.originimageView.image.size.height);
    if(indexPath.section==0){
        if (indexPath.row==0){
            self.imageView.image=[HGBWaterMarkTool imageDrawWithBaseImage:[UIImage imageNamed:@"test"] andWithImage:[UIImage imageNamed:@"icon"] andWithImageRect:CGRectMake(200, 100, 100, 100)];

        }else if (indexPath.row==1){
             self.imageView.image=[HGBWaterMarkTool imageDrawWithBaseImage:[UIImage imageNamed:@"test"] andWithText:@"hello world" andWithImageRect:CGRectMake(100, 100, 300, 100) andWithColor:[UIColor blackColor] andWithFont:[UIFont systemFontOfSize:50]];
        }else if (indexPath.row==2){

        }else if (indexPath.row==3){

        }else if (indexPath.row==4){

        }else if (indexPath.row==5){

        }else if (indexPath.row==6){

        }else if (indexPath.row==7){

        }

    }
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
