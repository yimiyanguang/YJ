//
//  HNav2ViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/10/27.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HNav2ViewController.h"
#import "HGBNavigationBarTool.h"
@interface HNav2ViewController ()

@end

@implementation HNav2ViewController
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewSetUp];
    [HGBNavigationBarTool createNavigationItem:HGBNavigationItemTitle andWithTitles:@[@"导航栏2"] andWithTarget:self andWithAction:@selector(returnhandler) inController:self];
     [HGBNavigationBarTool createNavigationItem:HGBNavigationItemLeft andWithTitles:@[@"返回"] andWithTarget:self andWithAction:@selector(returnhandler) inController:self];
   

}


//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UI
-(void)viewSetUp{
    self.view.backgroundColor=[UIColor blueColor];

}

@end
