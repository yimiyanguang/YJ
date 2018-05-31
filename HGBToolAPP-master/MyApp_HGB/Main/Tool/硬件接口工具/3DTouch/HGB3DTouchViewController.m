//
//  HGB3DTouchViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/1/28.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGB3DTouchViewController.h"

#import "HGBCommonSelectCell.h"
#import "UIViewController+HGB3DTouch.h"
#define Identify_Cell @"cell"
#import "HGB3DTouchNextViewController.h"

@interface HGB3DTouchViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
@end

@implementation HGB3DTouchViewController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI
    [self monitorWithWithPreviewBlock:^UIViewController *(CGPoint location, UIView *sourceView) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sourceView];
        NSLog(@"%@",indexPath);
        if(indexPath.section==0){
            if(indexPath.row==0){
                HGBView3DTouchSheetModel *model1=[HGBView3DTouchSheetModel instanceWithTitle:@"1" andWithPreviewActionStyle:(UIPreviewActionStyleDefault)];
                 HGBView3DTouchSheetModel *model2=[HGBView3DTouchSheetModel instanceWithTitle:@"2" andWithPreviewActionStyle:(UIPreviewActionStyleDestructive)];
                 HGBView3DTouchSheetModel *model3=[HGBView3DTouchSheetModel instanceWithTitle:@"3" andWithPreviewActionStyle:(UIPreviewActionStyleSelected)];
                [self set3DTouchSheetWithData:@[model1,model2,model3]];


            }else if (indexPath.row==1){
                HGBView3DTouchSheetModel *model1=[HGBView3DTouchSheetModel instanceWithTitle:@"A" andWithPreviewActionStyle:(UIPreviewActionStyleDefault)];
                HGBView3DTouchSheetModel *model2=[HGBView3DTouchSheetModel instanceWithTitle:@"B" andWithPreviewActionStyle:(UIPreviewActionStyleDestructive)];
                HGBView3DTouchSheetModel *model3=[HGBView3DTouchSheetModel instanceWithTitle:@"C" andWithPreviewActionStyle:(UIPreviewActionStyleSelected)];
                [self set3DTouchSheetWithData:@[model1,model2,model3]];

            }

        }
        HGB3DTouchNextViewController *setVC=[[HGB3DTouchNextViewController alloc]init];
        if(indexPath.section==0){
            if(indexPath.row==0){
                setVC.color=[UIColor redColor];

            }else if(indexPath.row==1){
                setVC.color=[UIColor blueColor];
            }
        }
        return setVC;
    } andWithsheetBlock:^(NSInteger index) {
         NSLog(@"%ld",index);

    }];
   

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
    titleLab.text=@"3DTouch";
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
    self.dataDictionary=@{@"3DTouch":@[@"3DTouch",@"3DTouch"]};
    self.keys=@[@"3DTouch"];

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
    [self add3DTocuhMonitorWithView:cell andWithBlock:^(BOOL status, NSDictionary *returnMessage) {
          NSLog(@"%@",returnMessage);
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    HGB3DTouchNextViewController *setVC=[[HGB3DTouchNextViewController alloc]init];
    if(indexPath.section==0){
        if(indexPath.row==0){
            setVC.color=[UIColor redColor];

        }else if(indexPath.row==1){
            setVC.color=[UIColor blueColor];
        }else{
            setVC.color=[UIColor grayColor];
        }

    }
    [self presentController:setVC];
    
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
