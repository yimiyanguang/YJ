//
//  HGBListController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/4.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBListController.h"

#import "HGBCommonListView.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0



@interface HGBListController ()<HGBCommonListViewDelegate>
/**
 全部数据源
 */
@property(strong,nonatomic)NSDictionary *dataDic;
/**
 本组数据源
 */
@property(strong,nonatomic)NSMutableArray *items;
/**
 分类数据源
 */
@property(strong,nonatomic)NSMutableArray *keys;
@end

@implementation HGBListController

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
    titleLab.text=@"工具组件集";
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



    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)];
    scrollView.backgroundColor=[UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];
    scrollView.alwaysBounceVertical=YES;
    scrollView.alwaysBounceHorizontal=NO;
    [self.view addSubview:scrollView];
    CGFloat x=0;
    CGFloat y=0;
    CGFloat w=kWidth;
    CGFloat h=0;
    for(int index=0;index<self.keys.count;index++){
        HGBFunctionModel *typeModel=self.keys[index];
        NSArray *array=[self.dataDic objectForKey:typeModel.page];
        self.items=[NSMutableArray array];
        for (NSDictionary *dic in array) {
            HGBFunctionModel *item=[HGBFunctionModel functionModelWithDictionary:dic];
            [self.items addObject:item];
        }
        NSInteger con=self.items.count/4;
        if ((self.items.count%4)) {
            con=con+1;
        }
        y=y+h;
        h=120*hScale*con+80*hScale;
        HGBCommonListView *functionView=[[HGBCommonListView alloc]initWithFrame:CGRectMake(x, y,w ,h) andWithTitle:typeModel.name andWithFunctionModels:self.items];
        functionView.index=index;
        functionView.delegate=self;
        [scrollView addSubview:functionView];
        y=y+30*hScale;
    }
    scrollView.contentSize=CGSizeMake(kWidth, h+y);






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

    }
    return _items;
}
-(NSMutableArray *)keys{
    if(_keys==nil){
        _keys=[NSMutableArray array];
        NSString *parh=[[NSBundle mainBundle]pathForResource:@"HGBFuncionType" ofType:@"plist"];
         NSArray *array=[NSArray arrayWithContentsOfFile:parh];
        for (NSDictionary *dic in array) {
            HGBFunctionModel *item=[HGBFunctionModel functionModelWithDictionary:dic];
            if(![item.page isEqualToString:@"detail"]){
                [_keys addObject:item];
            }

        }
    }
    return _keys;
}


@end
