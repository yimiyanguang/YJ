//
//  HGBCommonListView.h
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
@protocol HGBCommonListViewDelegate <NSObject>
/**
 点击了功能

 @param indexPath 位置
 @param item 选项
 */
-(void)commonListViewDidSelectFunctionAtIndex:(NSIndexPath *)indexPath andWithItem:(HGBFunctionModel *)item;
@end
@interface HGBCommonListView : UIView
/**
 代理
 */
@property(strong,nonatomic)id<HGBCommonListViewDelegate>delegate;
/**
 标记
 */
@property(assign,nonatomic)NSInteger index;
#pragma mark init
/**
 初始化

 @param frame 大小
 @param title 标题
 @param items 元素
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame andWithTitle:(NSString *)title andWithFunctionModels:(NSArray<HGBFunctionModel *>*)items;
@end
