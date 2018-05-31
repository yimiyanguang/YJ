//
//  HGBImageTool.h
//  CTTX
//
//  Created by huangguangbao on 16/10/4.
//  Copyright © 2016年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#ifdef DEBUG
#define HGBLogFlag YES
#else
#endif



/**
 类型
 */
typedef enum HGBImageToolColorProcessingImageType
{
    HGBImageToolColorProcessingImageTypeWhiteAndBlack,//黑白图片
    HGBImageToolColorProcessingImageTypeDusk,//黄昏
    HGBImageToolColorProcessingImageTypeSnow,//雪
    HGBImageToolColorProcessingImageTypeOther//原图


}HGBImageToolColorProcessingImageType;


/**
 图片处理工具
 */
@interface HGBImageTool : NSObject

#pragma mark 颜色转图片
/**
 颜色转图片

 @param color 颜色
 @return 图片
 */
+(UIImage *)imageFromColor:(UIColor*)color;
#pragma mark  剪切图片
/**
 *   剪切图片
 *
 *  @param image    原图片
 *  @param rect        剪切尺寸
 *
 *  return             剪切后图片
 */
+(UIImage*)cropImage:(UIImage*)image withRect:(CGRect)rect;

#pragma mark 图片尺寸变换
/**
 *   图片尺寸变换
 *
 *  @param image    原图片
 *  @param scaleSize       变换比例
 *
 *  return             变换后图片
 */
+ (UIImage *)configureImage:(UIImage *)image withScale:(CGFloat)scaleSize;

/**
 *   图片尺寸-将UIImage压缩到固定的宽度，高度也随之改变，而不变形
 *
 *  @param image    图片
 *  @param width    图片宽度
 *
 *  return             变换后图片
 */
+ (UIImage *)configureImage:(UIImage *)image withWidth:(CGFloat)width;

/**
 *   图片尺寸-将UIImage压缩到固定的宽度，高度也随之改变，而不变形
 *
 *  @param height    图片高度
 *  @param image    图片
 *  return             变换后图片
 */
+ (UIImage *)configureImage:(UIImage *)image withHeight:(CGFloat)height;
#pragma mark 图片大小压缩
/**
 *   图片大小压缩
 *
 *  @param bytes   字节
 *  @param image    图片
 *  return             变换后图片
 */
+ (UIImage *)configureImage:(UIImage *)image withBytes:(NSInteger)bytes;
/**
 *   图片大小压缩-不失真
 *
 *  @param bytes   字节
 *  @param image    图片
 *  return             变换后图片
 */
+ (UIImage *)configureImageWithoutDistort:(UIImage *)image withBytes:(NSInteger)bytes;

#pragma mark  图片旋转
/**
 *   图片旋转
 *
 *  @param image    原图片
 *  @param angle    变换角度
 *
 *  return             旋转后图片
 */
+ (UIImage *)rotateImage:(UIImage *)image withAngle:(CGFloat)angle;
#pragma mark  获取圆形或椭圆图片
/**
 *   获取圆形或椭圆图片
 *
 *  @param image    原图片
 *
 *  return             圆形图片
 */
+ (UIImage *)getRoundImage:(UIImage *)image;
#pragma mark  获取色彩处理图片
/**
 *   获取色彩处理图片
 *
 *  @param image    原图片
 *  @param type    0 黑白图片
 *
 *  return             色彩处理后图片
 */
+ (UIImage *)getColorProcessingImage:(UIImage *)image andWithType:(HGBImageToolColorProcessingImageType )type;
#pragma mark 图片组合
/**
 图片组合

 @param baseImage 基础图片
 @param images 图片集合
 @param imageRects 图片对应位置
 @return 组合后图片
 */
+(UIImage *)imageDrawWithBaseImage:(UIImage *)baseImage andWithImages:(NSArray<UIImage *>*)images andWithImageRects:(NSArray<NSString *>*)imageRects;
#pragma mark  图片方向-根据屏幕方向
/**
 *   图片方向-根据屏幕方向
 *
 *  @param image    原图片
 *  @param scaleSize       变换比例
 *
 *  return             旋转后图片
 */
+ (UIImage *)rotateImage:(UIImage *)image withScale:(CGFloat)scaleSize;
#pragma mark 图片方向处理
/**
 拍照图片方向处理

 @return 图片
 */
+(UIImage *)fixOrientationWithImage:(UIImage *)image;

@end
