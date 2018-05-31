//
//  HGBRollBallTool.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/1/19.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>






@interface HGBRollBallTool : NSObject
//参照视图，设置仿真范围）
@property (nonatomic, weak) UIView * referenceView;
+ (instancetype)shareBallTool;

- (void)addAimView:(UIView *)ballView referenceView:(UIView *)referenceView;

- (void)stopMotionUpdates;
@end
