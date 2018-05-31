
//
//  HGBRollBalViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/1/19.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBRollBalViewController.h"
#import "HGBRollBallView.h"
#import "HGBRollBallBezierPathView.h"

@interface HGBRollBalViewController ()

@end

@implementation HGBRollBalViewController

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
    titleLab.text=@"加速度计-滚动的小球";
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

    NSArray  * array = @[@"ball",@"eyes.png"];

    HGBRollBallBezierPathView * referenceView = [[HGBRollBallBezierPathView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    referenceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:referenceView];


    HGBRollBallView * ellipseBallView1 = [[HGBRollBallView alloc] initWithFrame:CGRectMake(30, 300, 30, 30) AndImageName:array[1]];
    [referenceView addSubview:ellipseBallView1];
    [ellipseBallView1 starMotion];

    HGBRollBallView * ellipseBallView2 = [[HGBRollBallView alloc] initWithFrame:CGRectMake(230, 300, 30, 30) AndImageName:array[1]];
    [referenceView addSubview:ellipseBallView2];
    [ellipseBallView2 starMotion];


    HGBRollBallView * ballView1 = [[HGBRollBallView alloc] initWithFrame:CGRectMake(100, 64, 40, 40) AndImageName:array[0]];
    [referenceView addSubview:ballView1];
    [ballView1 starMotion];

    HGBRollBallView * ballView2 = [[HGBRollBallView alloc] initWithFrame:CGRectMake(100, 64, 28, 28) AndImageName:array[0]];
    [referenceView addSubview:ballView2];
    [ballView2 starMotion];


    HGBRollBallView * ballView3 = [[HGBRollBallView alloc] initWithFrame:CGRectMake(100, 500, 28, 28) AndImageName:array[0]];
    [referenceView addSubview:ballView3];
    [ballView3 starMotion];

    HGBRollBallView * ballView4 = [[HGBRollBallView alloc] initWithFrame:CGRectMake(100, 500, 40, 40) AndImageName:array[0]];
    [referenceView addSubview:ballView4];
    [ballView4 starMotion];

}


- (void)dealloc{

    for (HGBRollBallBezierPathView * referenceView in self.view.subviews) {
        for (HGBRollBallView * ballView in referenceView.subviews) {
            [ballView stopMotion];
        }
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
