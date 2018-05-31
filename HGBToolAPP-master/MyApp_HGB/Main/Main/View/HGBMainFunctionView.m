//
//  HGBMainFunctionView.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/2.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBMainFunctionView.h"
@interface HGBMainFunctionView()
@property(strong,nonatomic)NSArray <HGBFunctionModel *>*items;
@end

@implementation HGBMainFunctionView
#pragma mark init
/**
 初始化

 @param frame 大小
 @param items 元素
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame andWithFunctionModels:(NSArray<HGBFunctionModel *>*)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items=items;
        [self viewSetUp];
    }
    return self;
}
#pragma mark view
-(void)viewSetUp{
    self.backgroundColor=[UIColor whiteColor];
    NSInteger con=0;
    if (self.items.count<4) {
        con=1;
    }else{
        con=self.items.count/4;
    }
    CGFloat itemWidth=self.frame.size.width*0.25;
    CGFloat itemHeight=self.frame.size.height/(con);

    CGFloat imageWidth=itemWidth*0.32;
    CGFloat imageHeight=itemWidth*0.32;
    CGFloat imageX=itemWidth*0.34;
    CGFloat imageY=itemHeight*0.23;

    CGFloat LabelWidth=itemWidth*0.8;
    CGFloat LabelHeight=itemHeight*0.15;
    CGFloat LabelX=itemWidth*0.1;
    CGFloat LabelY=itemHeight*0.8;



    for (int index=0; index<self.items.count;index++) {
        HGBFunctionModel *item=self.items[index];
        CGFloat itemY=((int)(index/4))*itemHeight;
        CGFloat itemX=((int)(index%4))*itemWidth;

        UIView *itemView=[[UIView alloc]initWithFrame:CGRectMake(itemX, itemY, itemWidth, itemHeight)];
        [self addSubview:itemView];

        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(imageX, imageY, imageWidth, imageHeight)];
        imageView.image=[UIImage imageNamed:item.image];
        [itemView addSubview:imageView];

        UILabel *nameLable=[[UILabel alloc]initWithFrame:CGRectMake(LabelX, LabelY, LabelWidth, LabelHeight)];
        nameLable.textColor=[UIColor blackColor];
        nameLable.backgroundColor=[UIColor clearColor];
        nameLable.textAlignment=NSTextAlignmentCenter;
        nameLable.text=item.name;
        nameLable.font=[UIFont systemFontOfSize:10];
        [itemView addSubview:nameLable];

        UIButton *clickButton=[UIButton buttonWithType:(UIButtonTypeSystem)];
        clickButton.frame=CGRectMake(0, 0, itemWidth, itemHeight);
        [clickButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        clickButton.tag=index;
        [itemView addSubview:clickButton];
    }

}
-(void)clickButtonAction:(UIButton *)_b{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(mainFunctionViewDidSelectFunctionAtIndex:andWithItem:)]) {
        [self.delegate mainFunctionViewDidSelectFunctionAtIndex:_b.tag andWithItem:self.items[_b.tag]];
    }
}
@end
