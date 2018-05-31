//
//  HGBCopyViewViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/12/22.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBCopyViewViewController.h"


#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"

#import "HGBCopyViewTool.h"


@interface HGBCopyViewViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDic;
/**
 数据源
 */
@property(strong,nonatomic)NSArray *keys;

/*
 表头
 */
@property(strong,nonatomic)UIView *headerView;

/**
 提示标签
 */
@property(strong,nonatomic)UILabel *promptLabel;
@end

@implementation HGBCopyViewViewController

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
    titleLab.text=@"组件复制工具";
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
    self.dataDic=@{@"组件复制:":@[@"组件复制"]};
    self.keys=@[@"组件复制:"];
    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];

    self.headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 160*hScale)];
    self.headerView.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView=self.headerView;

    self.promptLabel= [[UILabel alloc]initWithFrame:CGRectMake(30* wScale, 30*hScale,100*wScale, 100*hScale)];
    self.promptLabel.backgroundColor = [UIColor clearColor];
    self.promptLabel.text = @"hello";
    self.promptLabel.textColor = [UIColor blueColor];
    self.promptLabel.backgroundColor=[UIColor yellowColor];
    self.promptLabel.textAlignment = NSTextAlignmentLeft;
    self.promptLabel.font = [UIFont systemFontOfSize:12.0];
    self.promptLabel.numberOfLines = 0;
    [self.headerView addSubview:self.promptLabel];

}
#pragma mark table view delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.keys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 72 * hScale;
}
//-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return @[@"常用第三方"];
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 72* hScale)];
    headView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    //信息提示栏
    UILabel *tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(32 * wScale, 0, kWidth - 32 * wScale, CGRectGetHeight(headView.frame))];
    tipMessageLabel.backgroundColor = [UIColor clearColor];
    NSString *key=self.keys[section];
    tipMessageLabel.text = key;
    tipMessageLabel.textColor = [UIColor grayColor];
    tipMessageLabel.textAlignment = NSTextAlignmentLeft;
    tipMessageLabel.font = [UIFont systemFontOfSize:12.0];
    tipMessageLabel.numberOfLines = 0;
    [headView addSubview:tipMessageLabel];
    return headView;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key=self.keys[section];
    NSArray *data=self.dataDic[key];
    return data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGBCommonSelectCell *cell=[tableView dequeueReusableCellWithIdentifier:Identify_Cell forIndexPath:indexPath];
    NSString *key=self.keys[indexPath.section];
    NSArray *data=self.dataDic[key];
    NSString *string=[data objectAtIndex:indexPath.row];
    cell.title.text=string;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0){
        if(indexPath.row==0){

            static CGFloat x=0;
            if(x==0){
                x=30*wScale;
            }
            x=x+130*wScale;
            CGRect rect=CGRectMake(x, self.promptLabel.frame.origin.y, self.promptLabel.frame.size.width, self.promptLabel.frame.size.height); rect.origin.x=rect.origin.x+130*wScale;
            UIView *v=[HGBCopyViewTool duplicateComponent:self.promptLabel];
            v.frame=rect;
            [self.headerView addSubview:v];
        }
    }
}
-(void)presentController:(UIViewController*)controller{

    [self presentViewController:controller animated:YES completion:nil];
}
-(void)presentControllerWithNav:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark get
-(NSDictionary *)dataDic{
    if(_dataDic==nil){
        _dataDic=[NSDictionary dictionary];
    }
    return _dataDic;
}
-(NSArray *)keys{
    if(_keys==nil){
        _keys=[NSArray array];
    }
    return _keys;
}

@end
