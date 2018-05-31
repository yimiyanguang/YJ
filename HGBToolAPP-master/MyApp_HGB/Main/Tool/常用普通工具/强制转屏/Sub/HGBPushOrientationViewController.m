//
//  HGBPushOrientationViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/1/18.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBPushOrientationViewController.h"
#import "AppDelegate+HGBAPPOrientation.h"
@interface HGBPushOrientationViewController ()

@end

@implementation HGBPushOrientationViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *app=(id)[UIApplication sharedApplication].delegate;
    [app setAllowOrientation:(UIInterfaceOrientationMaskLandscape)];
    [app turnOrientation:(UIInterfaceOrientationLandscapeLeft)];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    AppDelegate *app=(id)[UIApplication sharedApplication].delegate;
    [app setAllowOrientation:(UIInterfaceOrientationMaskPortrait)];
    [app turnOrientation:(UIInterfaceOrientationPortrait)];

}
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
    titleLab.text=@"push屏幕转向工具";
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
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UI
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor yellowColor];
}



@end
