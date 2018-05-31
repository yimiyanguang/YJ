//
//  HGBINBluetoothViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/12/29.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBBluetoothViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "HGBINBluetoothTool.h"




@interface HGBBluetoothViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
/**
 媒体:拍照-相册
 */
@property(strong,nonatomic)UIImagePickerController *picker;
/**
 选择的图片
 */
@property(strong,nonatomic)UIImage *image;
/**
 相册按钮
 */
@property(strong,nonatomic)UIButton *photoButton;
/**
 相机按钮
 */
@property(strong,nonatomic)UIButton *cameraButton;


/**
 广播方状态
 */
@property(strong,nonatomic)UILabel *broadcastLabel;
/**
 广播按钮
 */
@property(strong,nonatomic)UIButton *broadcastButton;

/**
 广播方发送文本框
 */
@property(strong,nonatomic)UITextField *broadcastSendText;
/**
 广播方发送按钮
 */
@property(strong,nonatomic)UIButton *broadcastSendButton;
/**
 广播方发送图片按钮
 */
@property(strong,nonatomic)UIButton *broadcastSendImageButton;

/**
 广播方接收文本框
 */
@property(strong,nonatomic)UITextView *broadcastReciveText;
/**
 广播方接收图片框
 */
@property(strong,nonatomic)UIImageView *broadcastReciveImageView;






/**
 接收方状态
 */
@property(strong,nonatomic)UILabel *founderLabel;
/**
 接收按钮
 */
@property(strong,nonatomic)UIButton *founderButton;

/**
 接收方发送文本框
 */
@property(strong,nonatomic)UITextField *founderSendText;
/**
 接收方发送按钮
 */
@property(strong,nonatomic)UIButton *founderSendButton;
/**
 接收方发送图片按钮
 */
@property(strong,nonatomic)UIButton *founderSendImageButton;

/**
 接收方接收文本框
 */
@property(strong,nonatomic)UITextView *founderReciveText;
/**
 接收方接收图片框
 */
@property(strong,nonatomic)UIImageView *founderReciveImageView;

@end

@implementation HGBBluetoothViewController

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
    titleLab.text=@"苹果专用蓝牙工具";
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
    self.view.backgroundColor=[UIColor whiteColor];

    self.photoButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.photoButton.tag=0;
    [self.photoButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.photoButton.frame=CGRectMake(30*wScale, 80,(kWidth-90*wScale)*0.5, 30);
    [self.photoButton setTitle:@"相册选择图片" forState:(UIControlStateNormal)];
    [self.photoButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.photoButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.photoButton];


    self.cameraButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.cameraButton.tag=1;
    [self.cameraButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.cameraButton.frame=CGRectMake(60*wScale+(kWidth-90*wScale)*0.5, 80,(kWidth-90*wScale)*0.5, 30);
    [self.cameraButton setTitle:@"相机选择图片" forState:(UIControlStateNormal)];
    [self.cameraButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.cameraButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.cameraButton];

    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, 120, kWidth, 1)];
    line1.backgroundColor=[UIColor redColor];
    [self.view addSubview:line1];



#pragma mark 广播端

    UILabel *promptLabel=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale, 130, (kWidth-60*wScale), 20)];
    promptLabel.text=@"广播端";
    promptLabel.textColor=[UIColor blueColor];
    promptLabel.textAlignment=NSTextAlignmentCenter;
    promptLabel.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:promptLabel];




    self.broadcastLabel=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale, 160, (kWidth-90*wScale)*0.5, 30)];
    self.broadcastLabel.text=@"未开启";
    self.broadcastLabel.textColor=[UIColor blueColor];
    self.broadcastLabel.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:self.broadcastLabel];

    self.broadcastButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.broadcastButton.frame=CGRectMake(60*wScale+(kWidth-90*wScale)*0.5, 160,(kWidth-90*wScale)*0.5, 30);
    [self.broadcastButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.broadcastButton setTitle:@"开启广播模式" forState:(UIControlStateNormal)];
    self.broadcastButton.tag=2;
    [self.broadcastButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.broadcastButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.broadcastButton];

    self.broadcastSendText=[[UITextField alloc]initWithFrame:CGRectMake(30*wScale, 200, (kWidth-360*wScale), 30)];
    self.broadcastSendText.placeholder=@"请输入传输信息";
    self.broadcastSendText.layer.borderColor=[[UIColor grayColor]CGColor];
    self.broadcastSendText.layer.borderWidth=1;
    [self.view addSubview:self.broadcastSendText];


    self.broadcastSendButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.broadcastSendButton.tag=3;
    [self.broadcastSendButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.broadcastSendButton.frame=CGRectMake((kWidth-300*wScale), 200,120*wScale,30);
    [self.broadcastSendButton setTitle:@"发送消息" forState:(UIControlStateNormal)];
    [self.broadcastSendButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.broadcastSendButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.broadcastSendButton];


    self.broadcastSendImageButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.broadcastSendImageButton.tag=4;
    [self.broadcastSendImageButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.broadcastSendImageButton.frame=CGRectMake((kWidth-150*wScale), 200,120*wScale,30);
    [self.broadcastSendImageButton setTitle:@"发送图片" forState:(UIControlStateNormal)];
    [self.broadcastSendImageButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.broadcastSendImageButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.broadcastSendImageButton];

    self.broadcastReciveText=[[UITextView alloc]initWithFrame:CGRectMake(30*wScale, 240,(kWidth-90*wScale)*0.5,100)];
    self.broadcastReciveText.layer.borderColor=[[UIColor grayColor]CGColor];
    self.broadcastReciveText.layer.borderWidth=1;
    [self.view addSubview:self.broadcastReciveText];

    self.broadcastReciveImageView=[[UIImageView alloc]initWithFrame:CGRectMake(60*wScale+(kWidth-90*wScale)*0.5, 240,(kWidth-90*wScale)*0.5,100)];
    self.broadcastReciveImageView.layer.borderColor=[[UIColor grayColor]CGColor];
    self.broadcastReciveImageView.layer.borderWidth=1;
    [self.view addSubview:self.broadcastReciveImageView];


    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(0, 350, kWidth, 1)];
    line2.backgroundColor=[UIColor redColor];
    [self.view addSubview:line2];

#pragma mark 发现端

    UILabel *promptLabel2=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale, 360, (kWidth-60*wScale), 20)];
    promptLabel2.text=@"发现端";
    promptLabel2.textColor=[UIColor blueColor];
    promptLabel2.textAlignment=NSTextAlignmentCenter;
    promptLabel2.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:promptLabel2];


    self.founderLabel=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale, 390, (kWidth-90*wScale)*0.5, 30)];
    self.founderLabel.text=@"未开启";
    self.founderLabel.textColor=[UIColor blueColor];
    self.founderLabel.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:self.founderLabel];

    self.founderButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.founderButton.tag=5;
    [self.founderButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.founderButton.frame=CGRectMake(60*wScale+(kWidth-90*wScale)*0.5, 390,(kWidth-90*wScale)*0.5, 30);
    [self.founderButton setTitle:@"扫描蓝牙" forState:(UIControlStateNormal)];
    [self.founderButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.founderButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.founderButton];

    self.founderSendText=[[UITextField alloc]initWithFrame:CGRectMake(30*wScale, 430, (kWidth-360*wScale), 30)];
    self.founderSendText.placeholder=@"请输入传输信息";
    self.founderSendText.layer.borderColor=[[UIColor grayColor]CGColor];
    self.founderSendText.layer.borderWidth=1;
    [self.view addSubview:self.founderSendText];


    self.founderSendButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.founderSendButton.frame=CGRectMake((kWidth-300*wScale), 430,120*wScale,30);
    [self.founderSendButton setTitle:@"发送消息" forState:(UIControlStateNormal)];
    [self.founderSendButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.founderSendButton.tag=6;
    [self.founderSendButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.founderSendButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.founderSendButton];


    self.founderSendImageButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.founderSendImageButton.tag=7;
    [self.founderSendImageButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.founderSendImageButton.frame=CGRectMake((kWidth-150*wScale), 430,120*wScale,30);
    [self.founderSendImageButton setTitle:@"发送图片" forState:(UIControlStateNormal)];
    [self.founderSendImageButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.founderSendImageButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.founderSendImageButton];

    self.founderReciveText=[[UITextView alloc]initWithFrame:CGRectMake(30*wScale, 470,(kWidth-90*wScale)*0.5,100)];
    self.founderReciveText.layer.borderColor=[[UIColor grayColor]CGColor];
    self.founderReciveText.layer.borderWidth=1;
    [self.view addSubview:self.founderReciveText];

    self.founderReciveImageView=[[UIImageView alloc]initWithFrame:CGRectMake(60*wScale+(kWidth-90*wScale)*0.5, 470,(kWidth-90*wScale)*0.5,100)];
    self.founderReciveImageView.layer.borderColor=[[UIColor grayColor]CGColor];
    self.founderReciveImageView.layer.borderWidth=1;
    [self.view addSubview:self.founderReciveImageView];

    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0, 580, kWidth, 1)];
    line3.backgroundColor=[UIColor redColor];
    [self.view addSubview:line3];
}
#pragma mark button
-(void)buttonHandle:(UIButton *)_b{
    if(_b.tag==0){

        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
        {

            [self alertWithPrompt:@"由于您的设备不支持相册，您无法使用该功能!"];
            return;
        }else{
            self.picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            self.picker.delegate=self;
            self.picker.allowsEditing=NO;
            [self presentViewController:self.picker animated:YES completion:nil];


#ifdef __IPHONE_9_0
#else
            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];

            if (status == kCLAuthorizationStatusRestricted || status ==kCLAuthorizationStatusDenied)
            {

                NSString *errorStr = @"应用相册权限受限,请在设置中启用";
                [self alertWithPrompt:errorStr];
                return;
            }
#endif

        }

        return ;




    }else if (_b.tag==1){
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {


            [self alertWithPrompt:@"由于您的设备暂不支持摄像头，您无法使用该功能!"];
            return;
        }else{
            self.picker.sourceType=UIImagePickerControllerSourceTypeCamera;
            self.picker.cameraDevice=UIImagePickerControllerCameraDeviceRear;
            //设置捕获模式
            self.picker.cameraCaptureMode=UIImagePickerControllerCameraCaptureModePhoto;
            self.picker.delegate=self;
            self.picker.allowsEditing=NO;
            [self presentViewController:self.picker animated:YES completion:nil];




            NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
            if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){

                NSString *errorStr = @"应用相机权限受限,请在设置中启用";
                [self alertWithPrompt:errorStr];
                return;
            }
        }

    }else if (_b.tag==2){

    }else if (_b.tag==3){

    }else if (_b.tag==4){

    }else if (_b.tag==5){

    }else if (_b.tag==6){

    }else if (_b.tag==7){

    }else if (_b.tag==8){

    }
}
#pragma mark ImagePickerDelegate
//拿出图片
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //拍照及相册
    self.image=info[UIImagePickerControllerOriginalImage];
    //隐藏选取照片控制器
    [picker dismissViewControllerAnimated:YES completion:nil];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark prompt
-(void)alertWithPrompt:(NSString *)prompt{
#ifdef __IPHONE_8_0
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
#else
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:prompt delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    alertview.tag=0;
    [alertview show];
#endif
}

#pragma mark get
-(UIImagePickerController *)picker{
    if(_picker==nil){
        _picker=[[UIImagePickerController alloc]init];
        _picker.delegate=self;
    }
    return _picker;
}
@end

