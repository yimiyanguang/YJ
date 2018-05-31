//
//  HGBSignDrawer.m
//  sdk测试
//
//  Created by huangguangbao on 2017/8/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSignDrawer.h"
#import "HGBSignDrawView.h"



#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]//系统版本号
//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

@interface HGBSignDrawer ()
/**
 代理
 */
@property(assign,nonatomic)id<HGBSignDrawerDelegate>delegate;
/**
 父控制器
 */
@property(strong,nonatomic)UIViewController *parent;
/**
 灰层
 */
@property(strong,nonatomic)UIButton *grayHeaderView;
/**
 撤销按钮
 */
@property(strong,nonatomic)HGBSignDrawView *drawView;
/**
 撤销按钮
 */
@property(strong,nonatomic)UIButton *backButton;
/**
 撤销撤销按钮
 */
@property(strong,nonatomic)UIButton *forwordButton;
/**
 清除按钮
 */
@property(strong,nonatomic)UIButton *clearButton;

/**
 获取图片按钮
 */
@property(strong,nonatomic)UIButton *getButton;
/**
 保存到相册按钮
 */
@property(strong,nonatomic)UIButton *saveButton;
/**
 关闭按钮
 */
@property(strong,nonatomic)UIButton *closeButton;
@end

@implementation HGBSignDrawer
static HGBSignDrawer *instance=nil;
#pragma mark init
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBSignDrawerDelegate>)delegate{
    return [[HGBSignDrawer alloc]initWithParent:parent andWithDelegate:delegate];
}
- (instancetype)initWithParent:(UIViewController *)parent andWithDelegate:(id<HGBSignDrawerDelegate>)delegate
{
    self = [super init];
    if (self) {
        instance=self;
        self.parent=parent;
        self.delegate=delegate;
    }
    return self;
}
#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame=CGRectMake(20,100,kWidth-40,386);
    [self viewSetUp];

}
#pragma mark view
-(void)viewSetUp{
    self.view.layer.masksToBounds=YES;
    self.view.layer.borderColor=[[UIColor grayColor]CGColor];
    self.view.layer.borderWidth=2;
    self.view.backgroundColor=[UIColor lightGrayColor];
    self.view.layer.cornerRadius=10;

    self.drawView=[[HGBSignDrawView alloc]initWithFrame:CGRectMake(0,43, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-86)];
    self.drawView.layer.masksToBounds=YES;
    self.drawView.layer.borderColor=[[UIColor grayColor]CGColor];
    self.drawView.layer.borderWidth=1;
    if(self.lineColor){
        self.drawView.lineColor=self.lineColor;
    }
    if(self.lineWidth){
        self.drawView.lineWidth=self.lineWidth;
    }
    if(self.drawBackColor){
        self.drawView.backgroundColor=self.drawBackColor;
    }else{
        self.drawView.backgroundColor=[UIColor whiteColor];
    }
    [self.view addSubview:self.drawView];



    UIColor *titleColor;
    UIColor *backColor;
    if(self.buttonTitleColor){
        titleColor=self.buttonTitleColor;
    }else{
        titleColor=[UIColor blueColor];
    }
    if(self.buttonBackColor){
        backColor=self.buttonBackColor;
    }else{
        if(titleColor==[UIColor whiteColor]){
            backColor=[UIColor grayColor];
        }else{
            backColor=[UIColor whiteColor];
        }
    }


    CGFloat smallw=self.view.frame.size.width/3;
    CGFloat smallw_h=self.view.frame.size.width*0.25;


    //关闭按钮
    self.closeButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.closeButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.closeButton.titleLabel.font=[UIFont systemFontOfSize:17.7];
    self.closeButton.backgroundColor=backColor;
    self.closeButton.frame=CGRectMake(0,0,smallw_h,42);
    [self.closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(closeButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];


    //获取图片按钮
    self.getButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.getButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.getButton.titleLabel.font=[UIFont systemFontOfSize:17.7];
    self.getButton.backgroundColor=backColor;
    self.getButton.frame=CGRectMake(smallw_h*2.5,0,smallw_h*1.5,42);
    [self.getButton setTitle:@"获取图片" forState:UIControlStateNormal];
    [self.getButton addTarget:self action:@selector(getButtonHandler:) forControlEvents:UIControlEventTouchUpInside];



    //保存图片按钮
    self.saveButton=[UIButton buttonWithType:UIButtonTypeSystem];
    self.saveButton.backgroundColor=backColor;
    [self.saveButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.saveButton.titleLabel.font=[UIFont systemFontOfSize:17.7];
    self.getButton.backgroundColor=backColor;
    self.saveButton.frame=CGRectMake(smallw_h*2.5,0,smallw_h*1.5,42);
    [self.saveButton setTitle:@"保存到相册" forState:UIControlStateNormal];
    [self.saveButton addTarget:self action:@selector(saveButtonHandler:) forControlEvents:UIControlEventTouchUpInside];


    if(self.drawerType==HGBSignDrawerTypeNOSave){
        [self.view addSubview:self.getButton];
    }else if (self.drawerType==HGBSignDrawerTypeNOGet){
        [self.view addSubview:self.saveButton];
    }else{
        self.getButton.frame=CGRectMake(smallw_h*1,0,smallw_h*1.5,42);
        [self.view addSubview:self.getButton];
        [self.view addSubview:self.saveButton];
    }



    //撤销按钮
    self.backButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.backButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.backButton.titleLabel.font=[UIFont systemFontOfSize:17.7];
    self.backButton.backgroundColor=backColor;
    self.backButton.frame=CGRectMake(0,CGRectGetHeight(self.view.frame)-42,smallw,42);
    [self.backButton setTitle:@"撤销" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];


    //撤销撤销按钮
    self.forwordButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.forwordButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.forwordButton.titleLabel.font=[UIFont systemFontOfSize:17.7];
    self.forwordButton.backgroundColor=backColor;
    self.forwordButton.frame=CGRectMake(smallw,CGRectGetHeight(self.view.frame)-42,smallw,42);
    [self.forwordButton setTitle:@"上一步" forState:UIControlStateNormal];
    [self.forwordButton addTarget:self action:@selector(forwordButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forwordButton];


    //清除按钮
    self.clearButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [self.clearButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.clearButton.titleLabel.font=[UIFont systemFontOfSize:17.7];
    self.clearButton.backgroundColor=backColor;
    self.clearButton.frame=CGRectMake(smallw*2,CGRectGetHeight(self.view.frame)-42,smallw,42);
    [self.clearButton setTitle:@"清除" forState:UIControlStateNormal];
    [self.clearButton addTarget:self action:@selector(clearButtonHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.clearButton];


}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.drawView.layer.masksToBounds=YES;

    if(self.lineColor){
        self.drawView.lineColor=self.lineColor;
    }
    if(self.lineWidth){
        self.drawView.lineWidth=self.lineWidth;
    }
    if(self.drawBackColor){
        self.drawView.backgroundColor=self.drawBackColor;
    }else{
        self.drawView.backgroundColor=[UIColor whiteColor];
    }



    UIColor *titleColor;
    UIColor *backColor;
    if(self.buttonTitleColor){
        titleColor=self.buttonTitleColor;
    }else{
        titleColor=[UIColor blueColor];
    }
    if(self.buttonBackColor){
        backColor=self.buttonBackColor;
    }else{
        if(titleColor==[UIColor whiteColor]){
            backColor=[UIColor grayColor];
        }else{
            backColor=[UIColor whiteColor];
        }
    }


    CGFloat smallw=CGRectGetWidth(self.view.frame)/3;
    CGFloat smallw_h=CGRectGetWidth(self.view.frame)*0.25;


    //关闭按钮
    [self.closeButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.closeButton.backgroundColor=backColor;
    self.closeButton.frame=CGRectMake(0,0,smallw_h,42);

    //获取图片按钮
    [self.getButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.getButton.backgroundColor=backColor;
    self.getButton.frame=CGRectMake(smallw_h*2.5,0,smallw_h*1.5,42);

    //保存图片按钮
    [self.saveButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.getButton.backgroundColor=backColor;
    self.saveButton.frame=CGRectMake(smallw_h*2.5,0,smallw_h*1.5,42);

    if(self.drawerType==HGBSignDrawerTypeNOSave){
        if([self.saveButton superview]){
            [self.saveButton removeFromSuperview];
        }
        [self.view addSubview:self.getButton];
    }else if (self.drawerType==HGBSignDrawerTypeNOGet){
        if([self.getButton superview]){
            [self.getButton removeFromSuperview];
        }
        [self.view addSubview:self.saveButton];
    }else{
        self.getButton.frame=CGRectMake(smallw_h*1,0,smallw_h*1.5,42);
        [self.view addSubview:self.getButton];
        [self.view addSubview:self.saveButton];
    }



    //撤销按钮
    [self.backButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.backButton.backgroundColor=backColor;
    self.backButton.frame=CGRectMake(0,CGRectGetHeight(self.view.frame)-42,smallw,42);


    //撤销撤销按钮
    [self.forwordButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.forwordButton.backgroundColor=backColor;
    self.forwordButton.frame=CGRectMake(smallw,CGRectGetHeight(self.view.frame)-42,smallw,42);


    //清除按钮
    [self.clearButton setTitleColor:titleColor forState:(UIControlStateNormal)];
    self.clearButton.backgroundColor=backColor;
    self.clearButton.frame=CGRectMake(smallw*2,CGRectGetHeight(self.view.frame)-42,smallw,42);
}
#pragma mark handle
-(void)backButtonHandler:(UIButton *)_b{
    [self.drawView doBack];
}
-(void)forwordButtonHandler:(UIButton *)_b{
    [self.drawView doForward];
}
-(void)clearButtonHandler:(UIButton *)_b{
    [self.drawView clearDrawBoard];
}
-(void)getButtonHandler:(UIButton *)_b{
    UIImage *image= [self.drawView getDrawingImage];
    if(self.delegate&&[self.delegate respondsToSelector:@selector(signDrawer:didReturnImage:)]){
        [self.delegate signDrawer:self
                    didReturnImage:image];
    }
    if(self.isSaveToCache){
        [self saveImageToCaches:image];
    }

    if(!self.withoutCompleteClose){
        [self popViewRemoved];
    }
}
-(void)saveButtonHandler:(UIButton *)_b{
    [self.drawView savePhotoToAlbumWithImageBlock:^(BOOL status, UIImage *image, NSDictionary *returnMessage) {
        if(status){
            if(self.delegate&&[self.delegate respondsToSelector:@selector(signDrawer:didReturnImage:)]){
                [self.delegate signDrawer:self didReturnImage:image];
            }
            if(self.isSaveToCache){
                [self saveImageToCaches:image];
            }

            if(!self.withoutCompleteClose){
                [self popViewRemoved];
            }
        }else{
            if(self.delegate&&[self.delegate respondsToSelector:@selector(signDrawer:didFailedWithError:)]){
                [self.delegate signDrawer:self didFailedWithError:returnMessage];
            }

        }
    }];
}
-(void)closeButtonHandler:(UIButton *)_b{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(signDrawerDidCanceled:)]){
        [self.delegate signDrawerDidCanceled:self];
    }
    [self popViewRemoved];
}
/**
 保存到缓存

 @param image 图片
 */
-(void)saveImageToCaches:(UIImage *)image{
    NSString *lastPath=[NSString stringWithFormat:@"caches://signDrawer/%@.png",[self getSecondTimeStringSince1970]];
    NSString *url=[HGBSignDrawer urlAnalysis:lastPath];
    lastPath=[[NSURL URLWithString:url]path];
    NSString *directoryPath=[lastPath stringByDeletingLastPathComponent];
    if(![self isExitAtFilePath:directoryPath]){
        [self createDirectoryPath:directoryPath];
    }
    NSData *data=UIImagePNGRepresentation(image);
    [data writeToFile:lastPath atomically:YES];

    if([self isExitAtFilePath:lastPath]){
        if(self.delegate&&[self.delegate respondsToSelector:@selector(signDrawer:didReturnImagePath:)]){
            [self.delegate signDrawer:self didReturnImagePath:[HGBSignDrawer urlEncapsulation:lastPath]];
        }
    }
}
#pragma mark 弹出
//弹出视图
-(void)popInParentView
{
    if(instance){
        [instance popViewRemoved];
    }

    self.grayHeaderView=[UIButton buttonWithType:UIButtonTypeSystem];
    self.grayHeaderView.frame=[UIScreen mainScreen].bounds;
    self.grayHeaderView.tag=10;
    self.grayHeaderView.backgroundColor=[UIColor blackColor];
    self.grayHeaderView.alpha=0.3;
//    [self.grayHeaderView addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];

    [self.parent.view addSubview:self.grayHeaderView];

    self.view.frame=CGRectMake(20,(kHeight-CGRectGetHeight(self.view.frame))*0.5,kWidth-40,386);
    
    [self.parent.view addSubview:self.view];
    [self.parent addChildViewController:self];

    instance=self;
}
#pragma mark 弹出视图移除
-(void)popViewRemoved
{
    if([self.view superview]){
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
    if([self.grayHeaderView superview]){
        [self.grayHeaderView removeFromSuperview];
    }
    instance=nil;
}
#pragma mark url
/**
 判断路径是否是URL

 @param url url路径
 @return 结果
 */
+(BOOL)isURL:(NSString*)url{
    if([url hasPrefix:@"project://"]||[url hasPrefix:@"home://"]||[url hasPrefix:@"document://"]||[url hasPrefix:@"caches://"]||[url hasPrefix:@"tmp://"]||[url hasPrefix:@"defaults://"]||[url hasPrefix:@"/User"]||[url hasPrefix:@"/var"]||[url hasPrefix:@"http://"]||[url hasPrefix:@"https://"]||[url hasPrefix:@"file://"]){
        return YES;
    }else{
        return NO;
    }
}
/**
 url校验存在

 @param url url
 @return 是否存在
 */
+(BOOL)urlExistCheck:(NSString *)url{
    if(url==nil||url.length==0){
        return NO;
    }
    if(![HGBSignDrawer isURL:url]){
        return nil;
    }
    if(![url containsString:@"://"]){
        url=[[NSURL fileURLWithPath:url]absoluteString];
    }
    if([url hasPrefix:@"file://"]){
        NSString *filePath=[[NSURL URLWithString:url]path];
        if(filePath==nil||filePath.length==0){
            return NO;
        }
        NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
        return [filemanage fileExistsAtPath:filePath];
    }else{
        NSURL *urlCheck=[NSURL URLWithString:url];

        return [[UIApplication sharedApplication]canOpenURL:urlCheck];

    }
}
/**
 url解析

 @return 解析后url
 */
+(NSString *)urlAnalysisToPath:(NSString *)url{
    if(url==nil){
        return nil;
    }
    if(![HGBSignDrawer isURL:url]){
        return nil;
    }
    NSString *urlstr=[HGBSignDrawer urlAnalysis:url];
    return [[NSURL URLWithString:urlstr]path];
}
/**
 url解析

 @return 解析后url
 */
+(NSString *)urlAnalysis:(NSString *)url{
    if(url==nil){
        return nil;
    }
    if(![HGBSignDrawer isURL:url]){
        return nil;
    }
    if([url containsString:@"://"]){
        //project://工程包内
        //home://沙盒路径
        //http:// https://网络路径
        //document://沙盒Documents文件夹
        //caches://沙盒Caches
        //tmp://沙盒Tmp文件夹
        if([url hasPrefix:@"project://"]||[url hasPrefix:@"home://"]||[url hasPrefix:@"document://"]||[url hasPrefix:@"defaults://"]||[url hasPrefix:@"caches://"]||[url hasPrefix:@"tmp://"]){
            if([url hasPrefix:@"project://"]){
                url=[url stringByReplacingOccurrencesOfString:@"project://" withString:@""];
                NSString *projectPath=[[NSBundle mainBundle]resourcePath];
                url=[projectPath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"home://"]){
                url=[url stringByReplacingOccurrencesOfString:@"home://" withString:@""];
                NSString *homePath=NSHomeDirectory();
                url=[homePath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"document://"]){
                url=[url stringByReplacingOccurrencesOfString:@"document://" withString:@""];
                NSString  *documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
                url=[documentPath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"defaults://"]){
                url=[url stringByReplacingOccurrencesOfString:@"defaults://" withString:@""];
                NSString  *documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
                url=[documentPath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"caches://"]){
                url=[url stringByReplacingOccurrencesOfString:@"caches://" withString:@""];
                NSString  *cachesPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
                url=[cachesPath stringByAppendingPathComponent:url];
            }else if([url hasPrefix:@"tmp://"]){
                url=[url stringByReplacingOccurrencesOfString:@"tmp://" withString:@""];
                NSString *tmpPath =NSTemporaryDirectory();
                url=[tmpPath stringByAppendingPathComponent:url];
            }
            url=[[NSURL fileURLWithPath:url]absoluteString];

        }else{

        }
    }else {
        url=[[NSURL fileURLWithPath:url]absoluteString];
    }
    return url;
}
/**
 url封装

 @return 封装后url
 */
+(NSString *)urlEncapsulation:(NSString *)url{
    if(![HGBSignDrawer isURL:url]){
        return nil;
    }
    NSString *homePath=NSHomeDirectory();
    NSString  *documentPath =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) lastObject];
    NSString  *cachesPath =[NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES) lastObject];
    NSString *projectPath=[[NSBundle mainBundle]resourcePath];
    NSString *tmpPath =NSTemporaryDirectory();

    if([url hasPrefix:@"file://"]){
        url=[url stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    }
    if([url hasPrefix:projectPath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",projectPath] withString:@"project://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",projectPath] withString:@"project://"];
    }else if([url hasPrefix:documentPath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",documentPath] withString:@"defaults://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",documentPath] withString:@"defaults://"];
    }else if([url hasPrefix:cachesPath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",cachesPath] withString:@"caches://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",cachesPath] withString:@"caches://"];
    }else if([url hasPrefix:tmpPath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",tmpPath] withString:@"tmp://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",tmpPath] withString:@"tmp://"];
    }else if([url hasPrefix:homePath]){
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@/",homePath] withString:@"home://"];
        url=[url stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@",homePath] withString:@"home://"];
    }else if([url containsString:@"://"]){

    }else{
        url=[[NSURL fileURLWithPath:url]absoluteString];
    }
    return url;
}

#pragma mark 文件
/**
 文档是否存在

 @param filePath 归档的路径
 @return 结果
 */
-(BOOL)isExitAtFilePath:(NSString *)filePath{
    if(filePath==nil||filePath.length==0){
        return NO;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];//创建对象
    BOOL isExit=[filemanage fileExistsAtPath:filePath];
    return isExit;
}
/**
 创建文件夹

 @param directoryPath 路径
 @return 结果
 */
-(BOOL)createDirectoryPath:(NSString *)directoryPath{
    if([self isExitAtFilePath:directoryPath]){
        return YES;
    }
    NSFileManager *filemanage=[NSFileManager defaultManager];
    BOOL flag=[filemanage createDirectoryAtPath:directoryPath withIntermediateDirectories:NO attributes:nil error:nil];
    if(flag){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 获取时间
/**
 获取时间戳-秒级

 @return 秒级时间戳
 */
- (NSString *)getSecondTimeStringSince1970
{
    NSDate* date = [NSDate date];
    NSTimeInterval interval=[date timeIntervalSince1970];  //  *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", interval]; //转为字符型
    NSString *timeStr = [NSString stringWithFormat:@"%lf",[timeString doubleValue]*1000000];

    if(timeStr.length>=16){
        return [timeStr substringToIndex:16];
    }else{
        return timeStr;
    }
}
@end
