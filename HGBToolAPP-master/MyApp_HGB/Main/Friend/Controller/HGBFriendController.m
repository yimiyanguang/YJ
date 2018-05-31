//
//  HGBFriendController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/4.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBFriendController.h"

@interface HGBFriendController ()

@end

@implementation HGBFriendController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI
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
    titleLab.text=@"朋友";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    self.navigationItem.titleView=titleLab;


}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UI
-(void)viewSetUp{

}

@end
