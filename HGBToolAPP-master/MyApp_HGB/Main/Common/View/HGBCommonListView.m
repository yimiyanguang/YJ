//
//  HGBCommonListView.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/2.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBCommonListView.h"


@interface HGBCommonListView()
/**
 列表
 */
@property(strong,nonatomic)NSArray <HGBFunctionModel *>*items;
/**
 标题
 */
@property(strong,nonatomic)NSString *title;
@end

@implementation HGBCommonListView
/**
 初始化

 @param frame 大小
 @param title 标题
 @param items 元素
 @return 实例
 */
- (instancetype)initWithFrame:(CGRect)frame andWithTitle:(NSString *)title andWithFunctionModels:(NSArray<HGBFunctionModel *>*)items
{
    self = [super initWithFrame:frame];
    if (self) {
        self.items=items;
        self.title=title;
        [self viewSetUp];
    }
    return self;
}
#pragma mark view
-(void)viewSetUp{
    self.backgroundColor=[UIColor whiteColor];

    self.backgroundColor=[UIColor whiteColor];

    UILabel *titleLable=[[UILabel alloc]initWithFrame:CGRectMake(30*wScale, 0, kWidth-60*wScale, 24)];
    titleLable.textColor=[UIColor grayColor];
    titleLable.backgroundColor=[UIColor clearColor];
    titleLable.textAlignment=NSTextAlignmentLeft;
    titleLable.text=self.title;
    titleLable.font=[UIFont boldSystemFontOfSize:15];
    [self addSubview:titleLable];


    NSInteger con=self.items.count/4;
    if (self.items.count%4) {
        con=con+1;
    }

    CGFloat itemWidth=self.frame.size.width*0.25;
    CGFloat itemHeight=((CGFloat )(self.frame.size.height-30.0))/(con);

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
        CGFloat itemY=((int)(index/4))*itemHeight+30;
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
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commonListViewDidSelectFunctionAtIndex:andWithItem:)]) {
        [self.delegate commonListViewDidSelectFunctionAtIndex:[NSIndexPath indexPathForRow:_b.tag inSection:self.index] andWithItem:self.items[_b.tag]];
    }
}
@end
