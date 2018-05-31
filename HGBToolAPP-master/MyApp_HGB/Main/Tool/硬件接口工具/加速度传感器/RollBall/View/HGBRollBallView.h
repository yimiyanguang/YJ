//
//  HGBRollBallView.h
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/1/19.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HGBRollBallView : UIImageView
- (instancetype)initWithFrame:(CGRect)frame AndImageName:(NSString *)imageName;

- (void)starMotion;

- (void)stopMotion;
@end
