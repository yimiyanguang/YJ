//
//  HGBMainFunctionView.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/2.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGBFunctionModel.h"


/**
 代理
 */
@protocol HGBMainFunctionViewDelegate <NSObject>
/**
 点击了功能

 @param index 位置
 @param item 选项
 */
-(void)mainFunctionViewDidSelectFunctionAtIndex:(NSInteger)index andWithItem:(HGBFunctionModel *)item;
@end

@interface HGBMainFunctionView : UIView
/**
 代理
 */
@property(strong,nonatomic)id<HGBMainFunctionViewDelegate>delegate;
#pragma mark init
/**
 初始化

 @param frame 大小
 @param items 元素
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame andWithFunctionModels:(NSArray<HGBFunctionModel *>*)items;
@end
