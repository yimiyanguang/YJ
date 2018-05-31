//
//  HGBToolListController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/2.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBToolListController.h"
#import "HGBCommonListView.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0


@interface HGBToolListController ()<HGBCommonListViewDelegate>
/**
 全部数据源
 */
@property(strong,nonatomic)NSDictionary *dataDic;
/**
 本组数据源
 */
@property(strong,nonatomic)NSMutableArray *items;

@end

@implementation HGBToolListController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewSetUp];//UI
     [self createNavigationItem];//导航栏
     self.view.backgroundColor=[UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];

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
    titleLab.text=self.name;
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

    NSInteger con=self.items.count/4;
    if ((self.items.count%4)) {
        con=con+1;
    }


    HGBCommonListView *functionView=[[HGBCommonListView alloc]initWithFrame:CGRectMake(0, 64,kWidth , 120*hScale*con+80*hScale) andWithTitle:@"组件工具" andWithFunctionModels:self.items];
    functionView.index=0;
    functionView.delegate=self;
    [self.view addSubview:functionView];
    

}
#pragma mark delegate
-(void)commonListViewDidSelectFunctionAtIndex:(NSIndexPath *)indexPath andWithItem:(HGBFunctionModel *)item{
    if (item.page&&item.page.length!=0) {
        UIViewController *controller=(UIViewController *)[[NSClassFromString(item.page) alloc]init];
        [self presentController:controller];
    }
}

-(void)presentController:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark get
-(NSDictionary *)dataDic{
    if(_dataDic==nil){

        NSString *parh=[[NSBundle mainBundle]pathForResource:@"HGBFuntion" ofType:@"plist"];
        _dataDic=[NSDictionary dictionaryWithContentsOfFile:parh];
        if (_dataDic==nil) {
            _dataDic=[NSDictionary dictionary];
        }
    }
    return _dataDic;
}

#pragma mark get
-(NSMutableArray *)items{
    if(_items==nil){
        _items=[NSMutableArray array];



        NSArray *array=[self.dataDic objectForKey:self.pageId];
        for (NSDictionary *dic in array) {
            HGBFunctionModel *item=[HGBFunctionModel functionModelWithDictionary:dic];
            [_items addObject:item];
        }

    }
    return _items;
}
-(NSString *)pageId{
    if(_pageId==nil){
        _pageId=@"base";
    }
    return _pageId;
}
@end
