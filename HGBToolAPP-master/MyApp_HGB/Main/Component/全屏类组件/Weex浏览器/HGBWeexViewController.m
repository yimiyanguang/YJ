//
//  HGBWeexViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBWeexViewController.h"

#import "HGBWeexController.h"
#import "WeexSDKManager.h"

#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"

@interface HGBWeexViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBWeexViewController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI
//    在Appdelegate中调用或使用前调用
//    [WeexSDKManager baseSetup];
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
    titleLab.text=@"Weex浏览器";
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
    self.dataDictionary=@{@"Weex浏览器:":@[@"仅浏览器",@"带有关闭按钮-不可拖拽",@"带有关闭-贴边拖拽",@"带有关闭-拖拽",@"weex浏览器加载js字符串"]};
    self.keys=@[@"Weex浏览器:"];

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
            HGBWeexController *weexVC=[[HGBWeexController alloc]init];

            [weexVC loadJSSource:@"project://WeexBundle/bundlejs/app.weex.js"];
            [self presentViewController:weexVC animated:YES completion:nil];
        }else if (indexPath.row==1){
            HGBWeexController *weexVC=[[HGBWeexController alloc]init];
            [weexVC loadJSSource:@"project://WeexBundle/bundlejs/app.weex.js"];
            weexVC.isShowReturnButton=YES;
            weexVC.returnButtonPositionType=HGBWeexCloseButtonPositionTypeTopLeft;
            weexVC.returnButtonDragType=HGBWeexCloseButtonDragTypeNO;


            [self presentViewController:weexVC animated:YES completion:nil];
        }else if (indexPath.row==2){
            HGBWeexController *weexVC=[[HGBWeexController alloc]init];
            [weexVC loadJSSource:@"project://WeexBundle/bundlejs/app.weex.js"];
            weexVC.isShowReturnButton=YES;
            weexVC.returnButtonPositionType=HGBWeexCloseButtonPositionTypeTopLeft;
            weexVC.returnButtonDragType=HGBWeexCloseButtonDragTypeBorder;

            [self presentViewController:weexVC animated:YES completion:nil];
        }else if (indexPath.row==3){
            HGBWeexController *weexVC=[[HGBWeexController alloc]init];
            [weexVC loadJSSource:@"project://WeexBundle/bundlejs/app.weex.js"];
            weexVC.isShowReturnButton=YES;
            weexVC.returnButtonPositionType=HGBWeexCloseButtonPositionTypeTopLeft;
            weexVC.returnButtonDragType=HGBWeexCloseButtonDragTypeNOLimit;

            [self presentViewController:weexVC animated:YES completion:nil];
        }else if (indexPath.row==4){
            HGBWeexController *weexVC=[[HGBWeexController alloc]init];
            NSString *path=[[NSBundle mainBundle]pathForResource:@"WeexBundle" ofType:@""];
            path=[path stringByAppendingPathComponent:@"bundlejs/app.weex.js"];
            NSString *js=[[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
            [weexVC loadJSSource:js];

            weexVC.isShowReturnButton=YES;
            weexVC.returnButtonPositionType=HGBWeexCloseButtonPositionTypeTopLeft;
            weexVC.returnButtonDragType=HGBWeexCloseButtonDragTypeNOLimit;

            [self presentViewController:weexVC animated:YES completion:nil];
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
