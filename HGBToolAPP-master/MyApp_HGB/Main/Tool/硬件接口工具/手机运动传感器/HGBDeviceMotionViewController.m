//
//  HGBDeviceMotionViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/1/17.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBDeviceMotionViewController.h"
#import "HGBCommonSelectCell.h"
#define Identify_Cell @"cell"
#import "HGBDeviceMotionTool.h"

@interface HGBDeviceMotionViewController ()
/**
 数据源
 */
@property(strong,nonatomic)NSDictionary *dataDictionary;
/**
 关键字
 */
@property(strong,nonatomic)NSArray *keys;
/**
 图片容器
 */
@property(strong,nonatomic)UIImageView *imageView;
@end

@implementation HGBDeviceMotionViewController



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
    titleLab.text=@"手机运动传感器";
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
    self.dataDictionary=@{@"手机运动传感器":@[@"打开手机运动传感器",@"关闭"]};
    self.keys=@[@"手机运动传感器"];

    [self.tableView registerClass:[HGBCommonSelectCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];


    UIView *headerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 200)];
    headerView.backgroundColor=[UIColor lightGrayColor];
    self.tableView.tableFooterView=headerView;


    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(200, 20, 160, 160)];
    self.imageView.backgroundColor=[UIColor yellowColor];
    [headerView addSubview:self.imageView];
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
            [[HGBDeviceMotionTool shareInstance] setTimeInterval:1];
            [[HGBDeviceMotionTool shareInstance] startDeviceMotionWithReslut:^(BOOL status, NSDictionary *returnMessage) {
                NSLog(@"%@",returnMessage);
                if(status){
                    NSString *xStr=[returnMessage objectForKey:@"gravity_X"];
                    NSString *yStr=[returnMessage objectForKey:@"gravity_Y"];
//                    NSString *zStr=[returnMessage objectForKey:@"gravity_Z"];
                    CGFloat x=xStr.floatValue;
                    CGFloat y=yStr.floatValue;
//                    CGFloat z=zStr.floatValue;


                    //手机水平位置测试
//                    //判断y是否小于0，大于等于-1.0
//                    if(y < 0.0 && y >= -1.0){
//                        //设置旋转
//                        [self setRotation:80 * y withView:self.imageView];
//                    }else if (z* -1 > 0 && z * -1 <= 1.0){
//                        [self setRotation:80 - (80 * z * -1) withView:self.imageView];
//                    }

                    dispatch_async(dispatch_get_main_queue(), ^{
                        //X、Y方向上的夹角
                        double rotation = atan2(x, y) - M_PI;
                        NSLog(@"%.2f",rotation);
                        //图片始终保持垂直方向
                        self.imageView.transform = CGAffineTransformMakeRotation(rotation);
                    });
                }
            }];
        }else if(indexPath.row==1){
            [[HGBDeviceMotionTool shareInstance] stoptDeviceMotionWithReslut:^(BOOL status, NSDictionary *returnMessage) {


            }];
        }

    }
}
- (void)setRotation:(CGFloat)degress withView:(UIView *)view{

    CATransform3D tranform = CATransform3DIdentity;
    tranform.m34 = 1.0 / 100;
    CGFloat radiants = degress / 360 * M_PI;
    //旋转
    tranform = CATransform3DRotate(tranform, radiants, 1.0f, 0.0f, 0.0f);

    //锚点
    CALayer * layer = view.layer;
    layer.anchorPoint = CGPointMake(0.5, 0.5);
    layer.transform = tranform;

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
