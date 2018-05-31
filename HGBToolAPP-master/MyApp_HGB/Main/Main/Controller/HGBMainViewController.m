//
//  HGBMainViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/9/12.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBMainViewController.h"

#import "HGBMainFunctionView.h"
#import "HGBCirculateScrollView.h"
#import "HGBToolListController.h"
#import "HGBListController.h"


#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0


@interface HGBMainViewController ()<HGBMainFunctionViewDelegate>
/**
 数据源
 */
@property(strong,nonatomic)NSMutableArray *items;
/**
 banner
 */
@property(strong,nonatomic)NSArray *banner;




@end

@implementation HGBMainViewController

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

    //标题
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, kWidth, 16)];
    titleLab.font=[UIFont boldSystemFontOfSize:16];
    titleLab.text=@"主页";
    titleLab.textAlignment=NSTextAlignmentCenter;
    titleLab.textColor=[UIColor whiteColor];
    [self.view addSubview:titleLab];



}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)toolButtonHandle:(UIBarButtonItem *)_b{

}
#pragma mark UI
-(void)viewSetUp{
    UIImageView *topImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 420*hScale)];
    topImageView.image=[UIImage imageNamed:@"image_top"];
    [self.view addSubview:topImageView];

    NSDateFormatter *datef=[[NSDateFormatter alloc]init];
    datef.dateFormat=@"yyyy年MM月dd日";
    NSDateFormatter *timef=[[NSDateFormatter alloc]init];
    timef.dateFormat=@"HH:mm:ss";

    UILabel* dateLable=[[UILabel alloc]initWithFrame:CGRectMake(60*wScale, 260*hScale, kWidth-120*wScale, 30*hScale)];
    dateLable.textColor=[UIColor whiteColor];
    dateLable.backgroundColor=[UIColor clearColor];
    dateLable.textAlignment=NSTextAlignmentCenter;
    dateLable.text=[datef stringFromDate:[NSDate date]];
    dateLable.font=[UIFont systemFontOfSize:30*hScale];
    [topImageView addSubview:dateLable];


    UILabel* timeLable=[[UILabel alloc]initWithFrame:CGRectMake(60*wScale, 200*hScale, kWidth-120*wScale, 50*hScale)];
    timeLable.textColor=[UIColor whiteColor];
    timeLable.backgroundColor=[UIColor clearColor];
    timeLable.textAlignment=NSTextAlignmentCenter;
    timeLable.text=[timef stringFromDate:[NSDate date]];
    timeLable.font=[UIFont boldSystemFontOfSize:50*hScale];
    [topImageView addSubview:timeLable];
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDate *date=[NSDate date];
             timeLable.text=[timef stringFromDate:date];
             dateLable.text=[datef stringFromDate:date];
        });
    }];
    
    
     HGBMainFunctionView *functionView=[[HGBMainFunctionView alloc]initWithFrame:CGRectMake(0, 450*hScale,kWidth , 360*hScale) andWithFunctionModels:self.items];
    functionView.delegate=self;
    [self.view addSubview:functionView];






    HGBCirculateScrollView* bannerScollView=[[HGBCirculateScrollView alloc]initWithFrame:CGRectMake(0,810*hScale, kWidth,self.view.frame.size.height-810*hScale-44)];
    bannerScollView.PageControlPageIndicatorTintColor = [UIColor whiteColor];
    bannerScollView.pageControlCurrentPageIndicatorTintColor = [UIColor redColor];
    bannerScollView.autoTime = [NSNumber numberWithFloat:12.0f];

    [self.view addSubview:bannerScollView];

    NSMutableArray *viewArray=[NSMutableArray array];
    for(int  i=0;i<self.banner.count;i++){
        NSString *imageName=self.banner[i];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, bannerScollView.frame.size.width,bannerScollView.frame.size.height)];
        imageView.image=[UIImage imageNamed:imageName];
        [viewArray addObject:imageView];

        imageView.userInteractionEnabled=YES;
        UIButton *clickButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
        clickButton.frame=CGRectMake(0, 0, bannerScollView.frame.size.width, bannerScollView.frame.size.height);
        [clickButton addTarget:self action:@selector(imageButtonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
        clickButton.tag=i;
        [imageView addSubview:clickButton];
    }
    bannerScollView.slideViewsArray=viewArray;
    bannerScollView.isVerticalScroll=NO;
    bannerScollView.autoTime = [NSNumber numberWithFloat:4.0f];

    [bannerScollView startLoading];


}
-(void)imageButtonHandle:(UIButton *)_b{
    HGBListController *controller=[[HGBListController alloc]init];
    [self presentController:controller];
}
#pragma mark delegate
-(void)mainFunctionViewDidSelectFunctionAtIndex:(NSInteger)index andWithItem:(HGBFunctionModel *)item{
    if (item.page&&item.page.length!=0) {
        if(![item.page isEqualToString:@"detail"]){
            HGBToolListController *controller=[[HGBToolListController alloc]init];
            controller.pageId=item.page;
            controller.name=item.name;
            [self presentController:controller];
        }else{
            HGBListController *controller=[[HGBListController alloc]init];
            [self presentController:controller];
        }
    }
}
-(void)presentController:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self.tabBarController presentViewController:nav animated:YES completion:nil];
}
#pragma mark get
-(NSMutableArray *)items{
    if(_items==nil){
        _items=[NSMutableArray array];


        NSString *parh=[[NSBundle mainBundle]pathForResource:@"HGBFuncionType" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:parh];
        for (NSDictionary *dic in array) {
            HGBFunctionModel *item=[HGBFunctionModel functionModelWithDictionary:dic];
            [_items addObject:item];
        }

    }
    return _items;
}
#pragma mark get
-(NSArray *)banner{
    if(_banner==nil){
        _banner=@[@"banner1",@"banner2",@"banner3"];
    }
    return _banner;
}
@end
