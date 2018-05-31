//
//  HGBRootViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBRootViewController.h"

#import "HGBMainViewController.h"
#import "HGBCategoryController.h"
#import "HGBFriendController.h"
#import "HGBMyViewController.h"

@interface HGBRootViewController ()

@end

@implementation HGBRootViewController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewSetUp];
   
}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //导航栏
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:245.0/256 green:62.0/256 blue:42.0/256 alpha:1];
    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 136*wScale, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"我的应用";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;
    //右键
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"工具"  style:UIBarButtonItemStylePlain target:self action:@selector(toolButtonHandle:)];
    [self.navigationItem.rightBarButtonItem setImageInsets:UIEdgeInsetsMake(0, -15, 0, 5)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];

}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UI
-(void)viewSetUp{
    [self addSubControler:[[HGBMainViewController alloc]init] withTitle:@"首页" andWithImage:[UIImage imageNamed:@"icon_home_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_home_select"] andWithNavFlag:NO];
    [self addSubControler:[[HGBCategoryController alloc]init] withTitle:@"工具与组件" andWithImage:[UIImage imageNamed:@"icon_category_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_category_selected"] andWithNavFlag:NO];
    [self addSubControler:[[HGBFriendController alloc]init] withTitle:@"朋友" andWithImage:[UIImage imageNamed:@"icon_friend_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_friend_select"] andWithNavFlag:YES];
    [self addSubControler:[[HGBMyViewController alloc]init] withTitle:@"我的" andWithImage:[UIImage imageNamed:@"icon_my_normal"] andWithSelectorImage:[UIImage imageNamed:@"icon_ icon_my_select"] andWithNavFlag:YES];



}


-(void)toolButtonHandle:(UIBarButtonItem *)_b{
    
}
@end
