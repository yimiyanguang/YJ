//
//  HGBRollBallView.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/1/19.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBRollBallView.h"

#import "HGBRollBallTool.h"
@interface HGBRollBallView ()

@property (nonatomic, assign) UIDynamicItemCollisionBoundsType collisionBoundsType;

@property (nonatomic, strong) HGBRollBallTool * ball;

@end

@implementation HGBRollBallView

@synthesize collisionBoundsType;

- (instancetype)initWithFrame:(CGRect)frame AndImageName:(NSString *)imageName {

    if (self = [super initWithFrame:frame]) {

        self.image = [UIImage imageNamed:imageName];
        self.layer.cornerRadius = frame.size.width * 0.5;
        self.layer.masksToBounds = YES;
        self.collisionBoundsType = UIDynamicItemCollisionBoundsTypeEllipse;
    }

    return self;

}


- (void)starMotion {

    HGBRollBallTool * ball = [HGBRollBallTool shareBallTool];

    [ball addAimView:self referenceView:self.superview];
}

- (void)stopMotion{
    HGBRollBallTool * ball = [HGBRollBallTool shareBallTool];
    [ball stopMotionUpdates];
}
@end


