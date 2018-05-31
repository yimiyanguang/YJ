//
//  HGBDataBaseViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/19.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBDataBaseViewController.h"

#import "HGBDataBaseTool.h"
#import "HGBSEDataBaseTool.h"

#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"

@interface HGBDataBaseViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGBDataBaseViewController

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
    titleLab.text=@"数据库工具";
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
    self.dataDictionary=@{@"数据库工具1":@[@"数据库初始化-打开数据库",@"创建表格",@"数据库表格字段加密",@"查询数据库表格名称",@"表格改名",@"表格删除",@"添加记录",@"删除记录",@"更改记录",@"查询记录",@"查询表格字段名"],@"数据库工具2(带有加密功能的数据库)":@[@"数据库初始化-打开数据库",@"数据库加密",@"创建表格",@"数据库表格字段加密",@"查询数据库表格名称",@"表格改名",@"表格删除",@"添加记录",@"删除记录",@"更改记录",@"查询记录",@"查询表格字段名"]};
    self.keys=@[@"数据库工具1",@"数据库工具2(带有加密功能的数据库)"];

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
            [HGBSEDataBaseTool shareInstance];
        }else if (indexPath.row==1){
            [[HGBSEDataBaseTool shareInstance] createTableWithTableName:@"test" andWithKeys:@[@"id",@"name"] andWithPrimaryKey:@"id"];
            [[HGBSEDataBaseTool shareInstance] createTableWithTableName:@"test1" andWithKeys:@[@"id",@"name"] andWithPrimaryKey:@"id"];
            [[HGBSEDataBaseTool shareInstance] createTableWithTableName:@"test2" andWithKeys:@[@"id",@"name"] andWithPrimaryKey:@"id"];
            [[HGBSEDataBaseTool shareInstance] createTableWithTableName:@"test3" andWithKeys:@[@"id",@"name"] andWithPrimaryKey:@"id"];
        }else if (indexPath.row==2){
            [[HGBSEDataBaseTool shareInstance] encryptTableWithValueKeys:@[@"name"] andWithEncryptSecretKey:@"12121" inTableName:@"test"];

        }else if (indexPath.row==3){
            NSLog(@"%@",[[HGBSEDataBaseTool shareInstance] queryTableNames]);
        }else if (indexPath.row==4){
            [[HGBSEDataBaseTool shareInstance] renameTableWithTableName:@"test2" andWithNewTableName:@"test0"];
        }else if (indexPath.row==5){
            [[HGBSEDataBaseTool shareInstance] dropTableWithTableName:@"test3"];
            
        }else if (indexPath.row==6){
            [[HGBSEDataBaseTool shareInstance] addNode:@{@"name":@"huang1"} withTableName:@"test"];
            [[HGBSEDataBaseTool shareInstance] addNode:@{@"name":@"huang2"} withTableName:@"test"];
            [[HGBSEDataBaseTool shareInstance] addNode:@{@"name":@"huang3"} withTableName:@"test"];
            [[HGBSEDataBaseTool shareInstance] addNode:@{@"name":@"huang4"} withTableName:@"test"];
            [[HGBSEDataBaseTool shareInstance] addNode:@{@"name":@"huang5"} withTableName:@"test"];
            [[HGBSEDataBaseTool shareInstance] addNode:@{@"name":@"huang6"} withTableName:@"test"];
            [[HGBSEDataBaseTool shareInstance] addNode:@{@"name":@"huang7"} withTableName:@"test"];
            
        }else if (indexPath.row==7){
            [[HGBSEDataBaseTool shareInstance] removeNodesWithCondition:@{@"name":@"huang4"} inTableWithTableName:@"test"];
            
        }else if (indexPath.row==8){
            [[HGBSEDataBaseTool shareInstance] updateNodeWithCondition:@{@"name":@"huang7"} andWithChangeDic:@{@"name":@"huang0"}  inTableWithTableName:@"test"];
            
        }else if (indexPath.row==9){
            NSLog(@"%@",[[HGBSEDataBaseTool shareInstance] queryNodesWithCondition:@{} inTableWithTableName:@"test"]);
        }else if (indexPath.row==10){
            NSLog(@"%@",[[HGBSEDataBaseTool shareInstance] queryNodeKeysWithTableName:@"test"]);

            
        }

    }else if(indexPath.section==2){
        if (indexPath.row==0){
            [HGBDataBaseTool  shareInstance];
        }else if (indexPath.row==1){
            [[HGBDataBaseTool shareInstance] encryptDataBaseWithKey:@"hello"];
        }else if (indexPath.row==2){
            [[HGBDataBaseTool shareInstance] createTableWithTableName:@"test" andWithKeys:@[@"id",@"name"] andWithPrimaryKey:@"id"];
            [[HGBDataBaseTool shareInstance] createTableWithTableName:@"test1" andWithKeys:@[@"id",@"name"] andWithPrimaryKey:@"id"];
            [[HGBDataBaseTool shareInstance] createTableWithTableName:@"test2" andWithKeys:@[@"id",@"name"] andWithPrimaryKey:@"id"];
            [[HGBDataBaseTool shareInstance] createTableWithTableName:@"test3" andWithKeys:@[@"id",@"name"] andWithPrimaryKey:@"id"];
        }else if (indexPath.row==3){
            [[HGBDataBaseTool shareInstance] encryptTableWithValueKeys:@[@"name"] andWithEncryptSecretKey:@"12121" inTableName:@"test"];

        }else if (indexPath.row==4){
            NSLog(@"%@",[[HGBDataBaseTool shareInstance] queryTableNames]);
        }else if (indexPath.row==5){
            [[HGBDataBaseTool shareInstance] renameTableWithTableName:@"test2" andWithNewTableName:@"test0"];
        }else if (indexPath.row==6){
            [[HGBDataBaseTool shareInstance] dropTableWithTableName:@"test3"];

        }else if (indexPath.row==7){
            [[HGBDataBaseTool shareInstance] addNode:@{@"name":@"huang1"} withTableName:@"test"];
            [[HGBDataBaseTool shareInstance] addNode:@{@"name":@"huang2"} withTableName:@"test"];
            [[HGBDataBaseTool shareInstance] addNode:@{@"name":@"huang3"} withTableName:@"test"];
            [[HGBDataBaseTool shareInstance] addNode:@{@"name":@"huang4"} withTableName:@"test"];
            [[HGBDataBaseTool shareInstance] addNode:@{@"name":@"huang5"} withTableName:@"test"];
            [[HGBDataBaseTool shareInstance] addNode:@{@"name":@"huang6"} withTableName:@"test"];
            [[HGBDataBaseTool shareInstance] addNode:@{@"name":@"huang7"} withTableName:@"test"];

        }else if (indexPath.row==8){
            [[HGBDataBaseTool shareInstance] removeNodesWithCondition:@{@"name":@"huang4"} inTableWithTableName:@"test"];

        }else if (indexPath.row==9){
            [[HGBDataBaseTool shareInstance] updateNodeWithCondition:@{@"name":@"huang7"} andWithChangeDic:@{@"name":@"huang0"}  inTableWithTableName:@"test"];

        }else if (indexPath.row==10){
             NSLog(@"%@",[[HGBDataBaseTool shareInstance] queryNodesWithCondition:@{} inTableWithTableName:@"test"]);
        }else if (indexPath.row==11){
            NSLog(@"%@",[[HGBDataBaseTool shareInstance] queryNodeKeysWithTableName:@"test"]);


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
