//
//  HGBOnePicker.h
//  测试
//
//  Created by huangguangbao on 2017/9/13.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HGBOnePicker;
/**
 两项选择代理
 */
@protocol HGBOnePickerDelegate <NSObject>
@optional
/**
 选择

 @param title 信息
 */
-(void)onePicker:(HGBOnePicker *)picker didSelectedWithTitle:(NSString *)title;
/**
 选择

 @param index 坐标
 */
-(void)onePicker:(HGBOnePicker *)picker didSelectedWithIndex:(NSInteger)index;
/**
 取消
 */
-(void)onePickerDidCanceled:(HGBOnePicker *)picker;
@end

/**
 两项选择
 */
@interface HGBOnePicker : UIViewController
/**
 标题
 */
@property (nonatomic,strong)NSString *titleStr;
/**
 标识
 */
@property(assign,nonatomic)NSInteger index;
/**
 字体颜色
 */
@property(strong,nonatomic)UIColor *textColor;
/**
 字体大小
 */
@property(assign,nonatomic)CGFloat fontSize;
/**
 选中项
 */
@property(strong,nonatomic)NSString *selectedItem;
/**
 选中项
 */
@property(assign,nonatomic)NSInteger selectedIndex;
/**
 数据源:
 */
@property (nonatomic,strong)NSArray *dataSource;
/**
 是否排序
 */
@property(nonatomic,assign)BOOL isSequence;
/**
 创建
 */
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBOnePickerDelegate>)delegate;
/**
 弹出
 */
-(void)popInParentView;
@end
