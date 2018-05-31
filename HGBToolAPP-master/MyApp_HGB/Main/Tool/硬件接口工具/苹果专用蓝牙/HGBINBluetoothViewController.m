//
//  HGBINBluetoothViewController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2017/12/29.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBINBluetoothViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AVKit/AVKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "HGBINBluetoothTool.h"




@interface HGBINBluetoothViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,HGBINBluetoothToolDelegate>
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
 状态
 */
@property(strong,nonatomic)UILabel *statusLabel;
/**
 广播按钮
 */
@property(strong,nonatomic)UIButton *broadcastButton;

/**
 发送文本框
 */
@property(strong,nonatomic)UITextField *sendText;
/**
 发送按钮
 */
@property(strong,nonatomic)UIButton *sendMessageButton;
/**
 发送图片按钮
 */
@property(strong,nonatomic)UIButton *sendImageButton;

/**
 接收文本框
 */
@property(strong,nonatomic)UITextView *reciveText;
/**
 接收图片框
 */
@property(strong,nonatomic)UIImageView *reciveImageView;

/**
 接收按钮
 */
@property(strong,nonatomic)UIButton *founderButton;



@end

@implementation HGBINBluetoothViewController

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





    self.statusLabel=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale, 160, (kWidth-60*wScale), 30)];
    self.statusLabel.text=@"未开启";
    self.statusLabel.textColor=[UIColor blueColor];
    self.statusLabel.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:self.statusLabel];

    self.broadcastButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.broadcastButton.frame=CGRectMake(30*wScale, 200,(kWidth-90*wScale)*0.5, 30);
    [self.broadcastButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.broadcastButton setTitle:@"开启广播模式" forState:(UIControlStateNormal)];
    self.broadcastButton.tag=2;
    [self.broadcastButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.broadcastButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.broadcastButton];

    self.founderButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.founderButton.tag=3;
    [self.founderButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.founderButton.frame=CGRectMake(60*wScale+(kWidth-90*wScale)*0.5, 200,(kWidth-90*wScale)*0.5, 30);
    [self.founderButton setTitle:@"扫描蓝牙" forState:(UIControlStateNormal)];
    [self.founderButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.founderButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.founderButton];

    self.sendText=[[UITextField alloc]initWithFrame:CGRectMake(30*wScale, 240, (kWidth-360*wScale), 30)];
    self.sendText.placeholder=@"请输入传输信息";
    self.sendText.layer.borderColor=[[UIColor grayColor]CGColor];
    self.sendText.layer.borderWidth=1;
    [self.view addSubview:self.sendText];


    self.sendMessageButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.sendMessageButton.tag=4;
    [self.sendMessageButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.sendMessageButton.frame=CGRectMake((kWidth-300*wScale), 240,120*wScale,30);
    [self.sendMessageButton setTitle:@"发送消息" forState:(UIControlStateNormal)];
    [self.sendMessageButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.sendMessageButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.sendMessageButton];


    self.sendImageButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
    self.sendImageButton.tag=5;
    [self.sendImageButton addTarget:self action:@selector(buttonHandle:) forControlEvents:(UIControlEventTouchUpInside)];
    self.sendImageButton.frame=CGRectMake((kWidth-150*wScale), 240,120*wScale,30);
    [self.sendImageButton setTitle:@"发送图片" forState:(UIControlStateNormal)];
    [self.sendImageButton setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.sendImageButton.backgroundColor=[UIColor blueColor];
    [self.view addSubview:self.sendImageButton];

    self.reciveText=[[UITextView alloc]initWithFrame:CGRectMake(30*wScale, 280,(kWidth-90*wScale)*0.5,100)];
    self.reciveText.layer.borderColor=[[UIColor grayColor]CGColor];
    self.reciveText.layer.borderWidth=1;
    [self.view addSubview:self.reciveText];

    self.reciveImageView=[[UIImageView alloc]initWithFrame:CGRectMake(60*wScale+(kWidth-90*wScale)*0.5, 280,(kWidth-90*wScale)*0.5,100)];
    self.reciveImageView.layer.borderColor=[[UIColor grayColor]CGColor];
    self.reciveImageView.layer.borderWidth=1;
    [self.view addSubview:self.reciveImageView];


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

        [HGBINBluetoothTool shareInstanceWithServiceName:@"bluetooth" andWithBlueToothName:@"huang"];
        [[HGBINBluetoothTool shareInstance] startBroadCasting];
        [[HGBINBluetoothTool shareInstance] setDelegate:self];


    }else if (_b.tag==3){
        [HGBINBluetoothTool shareInstanceWithServiceName:@"bluetooth" andWithBlueToothName:@"zhang"];
        [[HGBINBluetoothTool shareInstance] scanBlueToothList];
        [[HGBINBluetoothTool shareInstance] setDelegate:self];

    }else if (_b.tag==4){
        if(self.sendText.text.length==0){
            [self alertWithPrompt:@"消息不能为空"];
            return;
        }

        [[HGBINBluetoothTool shareInstance] sendMessage:self.sendText.text];
    }else if (_b.tag==5){
        if(self.image==nil){
            [self alertWithPrompt:@"消息图片为空"];
            return;
        }
        
        [[HGBINBluetoothTool shareInstance] sendMessage:self.image];
        self.image=nil;
    }
}
#pragma mark bluetooth
-(void)inbluetooth:(HGBINBluetoothTool *)bluetooth didChangeStatus:(HGBINBluetoothToolStatus)status andWithStatusInfo:(NSDictionary *)statusInfo{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.statusLabel.text=@(status).stringValue;
    });

    NSLog(@"%@",statusInfo);
}
-(void)inbluetooth:(HGBINBluetoothTool *)bluetooth didFailedWithError:(NSDictionary *)errorInfo{
    NSLog(@"%@",errorInfo);
}
-(void)inbluetoothDidCancelBluetoothList:(HGBINBluetoothTool *)bluetooth{
    NSLog(@"cancel");
}
-(void)inbluetooth:(HGBINBluetoothTool *)bluetooth didReciveData:(NSData *)data answithUserName:(NSString *)userName{

}
-(void)inbluetooth:(HGBINBluetoothTool *)bluetooth didReciveMessage:(id)message andWithMessageType:(HGBINBluetoothToolDataType)dataType answithUserName:(NSString *)userName{
    dispatch_async(dispatch_get_main_queue(), ^{
        if(dataType==HGBINBluetoothToolDataTypeImage){
            self.reciveImageView.image=message;
        }else{
            self.reciveText.text=message;
        }
    });
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
