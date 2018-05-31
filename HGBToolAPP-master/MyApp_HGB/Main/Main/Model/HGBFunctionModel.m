//
//  HGBFunctionModel.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/2.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBFunctionModel.h"

@implementation HGBFunctionModel
/**
 快捷创建模型

 @param name 模型名称
 @param image 图片名称
 @param page 页面
 @return 模型
 */
+(HGBFunctionModel *)functionModelWithName:(NSString *)name andWithImage:(NSString *)image andWithPage:(NSString *)page{
    HGBFunctionModel *model=[[HGBFunctionModel alloc]init];
    model.name=name;
    model.page=page;
    model.image=image;
    return model;
}
/**
 快捷创建模型

 @param dic 模型字典
 @return 模型
 */
+(HGBFunctionModel *)functionModelWithDictionary:(NSDictionary *)dic{
    if (dic==nil) {
        return nil;
    }
    NSString *name=[dic objectForKey:@"name"];
    NSString *image=[dic objectForKey:@"image"];
    NSString *page=[dic objectForKey:@"page"];
    HGBFunctionModel *model=[[HGBFunctionModel alloc]init];
    model.name=name;
    model.page=page;
    model.image=image;
    return model;
}
@end
