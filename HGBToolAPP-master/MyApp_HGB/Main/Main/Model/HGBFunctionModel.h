//
//  HGBFunctionModel.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/2.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HGBFunctionModel : NSObject
/**
 名称
 */
@property(strong,nonatomic)NSString *name;
/**
 图片
 */
@property(strong,nonatomic)NSString *image;
/**
 跳转页面
 */
@property(strong,nonatomic)NSString *page;

/**
 快捷创建模型

 @param name 模型名称
 @param image 图片名称
 @param page 页面
 @return 模型
 */
+(HGBFunctionModel *)functionModelWithName:(NSString *)name andWithImage:(NSString *)image andWithPage:(NSString *)page;
/**
 快捷创建模型

 @param dic 模型字典
 @return 模型
 */
+(HGBFunctionModel *)functionModelWithDictionary:(NSDictionary *)dic;
@end
