//
//  HGBSignDrawView.m
//  啊啊啊
//
//  Created by huangguangbao on 2017/8/4.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBSignDrawView.h"

#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>




#define ReslutCode @"resultCode"
#define ReslutMessage @"resultMessage"

#ifdef HGBLogFlag
#define HGBLog(FORMAT,...) fprintf(stderr,"**********HGBErrorLog-satrt***********\n{\n文件名称:%s;\n方法:%s;\n行数:%d;\n提示:%s\n}\n**********HGBErrorLog-end***********\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],[[NSString stringWithUTF8String:__func__] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define HGBLog(...);
#endif


@interface HGBSignDrawView ()
/**
 存储线条路径
 */
@property (nonatomic, strong) NSMutableArray<UIBezierPath *> *paths;
/**
 记录回退的路径
 */
@property (nonatomic, strong) UIBezierPath *lastPath;
@end

@implementation HGBSignDrawView

#pragma mark - 绘图
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //1.获取UITouch对象
    UITouch *touch = [touches anyObject];
    //2.拿到触摸点
    CGPoint point = [touch locationInView:self];
    //3.创建贝塞尔曲线路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    //3.1设置路径的相关属性
    [path setLineJoinStyle:kCGLineJoinRound];
    [path setLineCapStyle:kCGLineCapRound];

    //4.设置当前路径的起点
    [path moveToPoint:point];

    //5.添加路径到数组中
    [self.paths addObject:path];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //1.获取UITouch对象
    UITouch *touch = [touches anyObject];
    //2.拿到触摸点
    CGPoint point = [touch locationInView:self];

    //3.取出当前路径
    UIBezierPath *path = [self.paths lastObject];
    //4.设置当前路径终点
    [path addLineToPoint:point];
    //5.调用drawRect方法进行重绘
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self touchesMoved:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect {
    //设置线条颜色
    if(self.lineColor){
        [self.lineColor set];
    }else{
        [[UIColor blackColor] set];
    }


    for (UIBezierPath *path in self.paths) {
        if(self.lineWidth!=0){
             [path setLineWidth:self.lineWidth];
        }else{
             [path setLineWidth:5];
        }

        //渲染路径
        [path stroke];
    }
}

#pragma mark - 线条设置
#pragma mark 操作

/**
 清空画板
 */
- (void)clearDrawBoard{
    [self.paths removeAllObjects];
    [self setNeedsDisplay];
}

/**
 后退
 */
- (void)doBack{
    self.lastPath = [self.paths lastObject];
    [self.paths removeLastObject];
    [self setNeedsDisplay];
}

/**
 前进
 */
- (void)doForward{

    if (self.lastPath) {
        [self.paths addObject:self.lastPath];
        [self setNeedsDisplay];
    }
    self.lastPath = nil;
}

/**
 获取画图

 @return 图片
 */
-(UIImage *)getDrawingImage
{

    if(self.paths.count!=0){
        UIGraphicsBeginImageContext(self.frame.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIRectClip(CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
        [self.layer renderInContext:context];
        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        return image;
    }else{
        return nil;
    }
}
/**
 保存到相册

 @param imageBlock 保存成功回调
 */
- (void)savePhotoToAlbumWithImageBlock:(HGBSignDrawImageBlock)imageBlock{
    if(![self isCanSavePhotos]){
        HGBLog(@"相册权限不足");
        imageBlock(NO,nil,@{ReslutCode:@(HGBSignDrawErrorTypeDevice).stringValue,ReslutMessage:@"相册权限不足"});
        return ;
    }
    if(self.paths.count!=0){
        // 截屏
        UIGraphicsBeginImageContext(self.bounds.size);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        // 截取画板尺寸
        CGImageRef sourceImageRef = [image CGImage];
        CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef];

        // 截图保存相册
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);

        if(![self isCanSavePhotos]){
            HGBLog(@"相册权限不足");
            imageBlock(NO,nil,@{ReslutCode:@(HGBSignDrawErrorTypeDevice).stringValue,ReslutMessage:@"相册权限不足"});
            return ;
        }


        if (imageBlock) {
            imageBlock(YES,newImage,nil);
        }
    }else{
        if (imageBlock) {
            imageBlock(YES,nil,@{ReslutCode:@(HGBSignDrawErrorTypeParams).stringValue,ReslutMessage:@"签名为空"});
        }
    }
}
#pragma mark 权限判断
/**
 相册权限判断

 @return 是否有权限
 */
- (BOOL)isCanSavePhotos {

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
         HGBLog(@"%ld",status);
    }];


    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        return NO;
    }
#ifdef __IPHONE_8_0
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //无权限
        return NO;
    }
#else
    ALAuthorizationStatus author =[ALAssetsLibrary authorizationStatus];
    if (author == kCLAuthorizationStatusRestricted || author == kCLAuthorizationStatusDenied) {
        //无权限
        return NO;
    }
#endif
    return YES;
}

#pragma mark set
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor=lineColor;
    [self setNeedsDisplay];
}
-(void)setLineWidth:(CGFloat)lineWidth{
    _lineWidth=lineWidth;
    [self setNeedsDisplay];
}
#pragma mark get
- (NSMutableArray *)paths {
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}


@end
