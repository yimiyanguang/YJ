//
//  HGBMediaImageController.h
//  测试
//
//  Created by huangguangbao on 2017/8/23.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef DEBUG
#define HGBLogFlag YES
#else
#endif

//快捷url提示
/**
 project://工程包内
 home://沙盒路径
 http:// https://网络路径
 document://  或defaults://沙盒Documents文件夹
 caches://沙盒Caches
 tmp://沙盒Tmp文件夹

 */


@class HGBMediaImageController;
@protocol HGBMediaImageControllerDelegate <NSObject>
@optional
/**
 关闭
 */
-(void)fileImageControllerDidClosed;
@end
@interface HGBMediaImageController : UIViewController
@property(strong,nonatomic)NSString *url;
@property(assign,nonatomic)id<HGBMediaImageControllerDelegate>delegate;

@end
