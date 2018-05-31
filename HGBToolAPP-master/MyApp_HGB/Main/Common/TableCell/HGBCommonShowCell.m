//
//  HGBCommonShowCell.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/4.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBCommonShowCell.h"

@implementation HGBCommonShowCell
#pragma mark init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_ViewSetUp];
    }
    return self;
}
#pragma mark view
-(void)p_ViewSetUp
{

    
    self.contentView.backgroundColor=[UIColor whiteColor];
    self.alpha=1;

    self.imgV=[[UIImageView alloc]initWithFrame:CGRectMake(30*wScale,8.5,36,36)];
    self.imgV.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:self.imgV];

    self.title=[[UILabel alloc]initWithFrame:CGRectMake(60*wScale+36,0,kWidth-90*wScale-36,53)];
    self.title.text=@"标题";
    self.title.textAlignment=NSTextAlignmentLeft;
    self.title.backgroundColor=[UIColor whiteColor];
    self.title.font=[UIFont systemFontOfSize:17.7];
    self.title.textColor=[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1];
    [self.contentView addSubview:self.title];
}

@end
