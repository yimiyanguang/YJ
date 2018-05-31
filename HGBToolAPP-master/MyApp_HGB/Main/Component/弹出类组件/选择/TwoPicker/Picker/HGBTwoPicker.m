//
//  HGBTwoPicker.m
//  CTTX
//
//  Created by huangguangbao on 17/1/8.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBTwoPicker.h"
#import "HGBTwoPickerHeader.h"


@interface HGBTwoPicker ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger _firstIndex;//第一列坐标
    NSInteger _secondIndex;//第二列坐标
}
@property(assign,nonatomic)id<HGBTwoPickerDelegate>delegate;
/**
 父控制器
 */
@property(strong,nonatomic)UIViewController *parent;
/**
 视图
 */
@property(strong,nonatomic)UIWindow *window;

/**
 背景
 */
@property (nonatomic,strong)UIView *backgroudView;
/**
 选择控制器
 */
@property (nonatomic,strong)UIPickerView *pickerView;

/**
 第一列数组
 */
@property (nonatomic,strong)NSMutableArray *firstTypesArr;
/**
 第二列数组
 */
@property (nonatomic,strong)NSMutableArray *secondTypesArr;
/**
 结果数组
 */
@property (nonatomic,strong)NSMutableArray *souceArr;

/**
 提示
 */
@property(strong,nonatomic)UILabel *promptLab;
/**
 灰层
 */
@property(strong,nonatomic)UIButton *grayHeaderView;

/**
 确认按钮
 */
@property(strong,nonatomic) UIButton *okButton;
/**
 取消按钮
 */
@property(strong,nonatomic) UIButton *cancelButton;
@end

@implementation HGBTwoPicker

static HGBTwoPicker *obj=nil;
#pragma mark init
+(instancetype)instanceWithParent:(UIViewController *)parent andWithDelegate:(id<HGBTwoPickerDelegate>)delegate{
    return [[[self class]alloc]initWithParent:parent andWithDelegate:delegate];
}
-(instancetype)initWithParent:(UIViewController *)parent andWithDelegate:(id<HGBTwoPickerDelegate>)delegate
{
    self = [super init];
    if (self) {
        self.delegate=delegate;
        self.parent=parent;
        [self viewSetUp];
        
    }
    return self;
}

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    //大小位置
    
    
}
#pragma mark view
-(void)viewSetUp{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _firstIndex = 0;
    _secondIndex = 0;
    
    self.view.frame=CGRectMake(0, 0,kWidth,700*hScale);
    
    self.firstTypesArr = [NSMutableArray array];
    self.secondTypesArr = [NSMutableArray array];
    self.souceArr = [NSMutableArray array];

    
    self.backgroudView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 700 * hScale)];
    self.backgroudView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroudView];
    
    UIView *tempView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 96 * hScale)];
    tempView.backgroundColor = [UIColor whiteColor];
    [self.backgroudView addSubview:tempView];
    
    
    UIButton *closeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    closeButton.frame = CGRectMake(20 * wScale, 34 * hScale, 100 * wScale, 28 * wScale);
    [closeButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [closeButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    [closeButton addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    closeButton.tag = 200;
    [tempView addSubview:closeButton];
    
    
    self.cancelButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.cancelButton .frame = CGRectMake(0 * wScale, 0 * hScale, 96 * wScale, 96 * wScale);
    
    [self.cancelButton  addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    self.cancelButton .tag = 201;
    [tempView addSubview:self.cancelButton ];
    
    self.okButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.okButton.backgroundColor = [UIColor clearColor];
    self.okButton.frame = CGRectMake(kWidth - 50 - 30 * wScale, 0, 50, 96 * hScale);
    [self.okButton setTitle:@"确定" forState:(UIControlStateNormal)];
    [self.okButton setTitleColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1] forState:(UIControlStateNormal)];
    [self.okButton addTarget:self action:@selector(okButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    [tempView addSubview:self.okButton];
    
    
    
    self.promptLab=[[UILabel alloc]initWithFrame:CGRectMake(120*wScale, 0, kWidth-240*wScale, 70*hScale)];
    self.promptLab.text=@"时间选择器";
    self.promptLab.font=[UIFont systemFontOfSize:32*hScale];
    self.promptLab.textColor=[UIColor blackColor];
    self.promptLab.textAlignment=NSTextAlignmentCenter;
    self.promptLab.backgroundColor=[UIColor whiteColor];
    
    
    
    UIImageView *lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(tempView.frame) - 1, kWidth, 1)];
    lineImageView.image = [UIImage imageNamed:@"line_cell_H"];
    [tempView addSubview:lineImageView];
    
    
    self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tempView.frame), kWidth, 604 * hScale)];
    self.pickerView.backgroundColor = [UIColor whiteColor];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.backgroudView addSubview:self.pickerView];
}
#pragma mark 弹出视图
//弹出视图
-(void)popInParentView
{
    if(obj){
        [obj popViewRemoved];
    }
    
    NSString *firstStr,*secondStr;
    if(self.selectedItems.count>=2){
        firstStr=self.selectedItems[0];
        secondStr=self.selectedItems[1];
    }else if(self.selectedItems.count>=1){
        firstStr=self.selectedItems[0];
    }
    NSArray *keyArr = [self.dataSource allKeys];
    if(self.isSequence){
          keyArr=[keyArr sortedArrayUsingSelector:@selector(compare:)];
    }
    int i=0,j=0;
    for(i=0;i<keyArr.count;i++){
        NSString *key=keyArr[i];
        if(firstStr){
            if([key isEqualToString:firstStr]){
                break;
            }
        }
       
    }
    if(i==keyArr.count){
        if(keyArr.count>self.firstSelectedIndex&&self.firstSelectedIndex>0){
            i=(int)self.firstSelectedIndex;
        }else{
            i=0;
        }
    }
    self.firstTypesArr=[NSMutableArray arrayWithArray:keyArr];
    _firstIndex=i;
    NSString *keyStr = [self.firstTypesArr objectAtIndex:_firstIndex];
    
    NSArray *secondArr = [_dataSource objectForKey:keyStr];
    
    for(j=0;j<secondArr.count;j++){
        NSString *key=secondArr[j];
        if(secondStr){
            if([key isEqualToString:secondStr]){
                break;
            }
        }
    }
    if(j==secondArr.count){
        if(secondArr.count>self.secondSelectedIndex&&self.secondSelectedIndex>0){
            j=(int)self.secondSelectedIndex;
        }else{
            j=0;
        }
    }
    _secondIndex=j;
    self.secondTypesArr=[NSMutableArray arrayWithArray:secondArr];
    [self.pickerView selectRow:_firstIndex inComponent:0 animated:NO];
    [self.pickerView selectRow:_secondIndex inComponent:1 animated:NO];
    [self.pickerView reloadComponent:1];
    
    self.souceArr=[NSMutableArray arrayWithObjects:keyStr,self.secondTypesArr[j], nil];
    
    
    
    
    if(self.titleStr&&self.titleStr.length!=0){
        
        if(![self.promptLab superview]){
            self.promptLab.text=self.titleStr;
            [self.view addSubview:self.promptLab];
        }
    }else{
        if([self.promptLab superview]){
            [self.promptLab removeFromSuperview];
        }
    }
    
    
    self.grayHeaderView=[UIButton buttonWithType:UIButtonTypeSystem];
    self.grayHeaderView.frame=[UIScreen mainScreen].bounds;
    self.grayHeaderView.tag=10;
    self.grayHeaderView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [self.grayHeaderView addTarget:self action:@selector(cancelButtonHandler:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.window addSubview:self.grayHeaderView];
    self.view.frame=CGRectMake(0,kHeight, kWidth, 700*hScale);
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame=CGRectMake(0,kHeight-700*hScale, kWidth, 700*hScale);
    }];
    
    [self.grayHeaderView addSubview:self.view];
    [self.parent addChildViewController:self];
    
    
    obj=self;
}
#pragma mark 视图消失
-(void)popViewDisappearWithSucessBlock:(void (^)(void))successBlock
{
    [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        self.view.transform=CGAffineTransformTranslate(self.view.transform,0,1000*hScale);
    } completion:^(BOOL finished) {
        successBlock();
        [self popViewRemoved];
    }];
}

#pragma mark 弹出视图移除
-(void)popViewRemoved
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    [self.grayHeaderView removeFromSuperview];
    obj=nil;
}
#pragma mark buttonHandler
//确认
-(void)okButtonHandler:(UIButton *)_b
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(twoPicker: didSelectedWithTitleArr:)]){
        [self.delegate twoPicker:self didSelectedWithTitleArr:self.souceArr];

    }
    if(self.delegate&&[self.delegate respondsToSelector:@selector(twoPicker: didSelectedWithFirstIndex:andWithSecondIndex:)]){
        [self.delegate twoPicker:self didSelectedWithFirstIndex:_firstIndex andWithSecondIndex:_secondIndex];

    }
    [self popViewDisappearWithSucessBlock:^{

    }];

}
//取消
-(void)cancelButtonHandler:(UIButton *)_b
{
    if(self.delegate&&[self.delegate respondsToSelector:@selector(twoPickerDidCanceled:)]){
        [self.delegate twoPickerDidCanceled:self];
    }
    [self popViewDisappearWithSucessBlock:^{
        
    }];
}
#pragma mark Picker Data Source Methed
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return [self.firstTypesArr count];
    }else{
        return [self.secondTypesArr count];
    }
}

#pragma mark Picker Delegate Methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)componen
{
    if (componen == 0) {
        return [self.firstTypesArr objectAtIndex:row];
    }else{
        return [self.secondTypesArr objectAtIndex:row];
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        if(self.fontSize!=0){
            [pickerLabel setFont:[UIFont boldSystemFontOfSize:self.fontSize]];
        }else{
            [pickerLabel setFont:[UIFont boldSystemFontOfSize:15]];
        }
        if(self.textColor){
            pickerLabel.textColor=self.textColor;
        }else{
            pickerLabel.textColor=[UIColor blackColor];
        }
    }
   
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.secondTypesArr=[NSMutableArray array];
    self.souceArr=[NSMutableArray array];
    
    
    if (component == 0) {
        _firstIndex = row;
        _secondIndex = 0;
        NSString *keyStr = [self.firstTypesArr objectAtIndex:_firstIndex];
        self.secondTypesArr=[_dataSource objectForKey:keyStr];
        [self.pickerView reloadComponent:1];
        [self.pickerView selectRow:0 inComponent:1 animated:YES];
        
    }else if (component == 1){
        _secondIndex = row;
        NSString *keyStr = [self.firstTypesArr objectAtIndex:_firstIndex];
        self.secondTypesArr=[_dataSource objectForKey:keyStr];;
    }
    [self.pickerView reloadComponent:1];
    NSString *keyStr = [self.firstTypesArr objectAtIndex:_firstIndex];
    NSArray *secondArr = [_dataSource objectForKey:keyStr];
    self.souceArr=[NSMutableArray arrayWithObjects:keyStr,[secondArr objectAtIndex:_secondIndex], nil];
    [self.pickerView reloadComponent:1];
}
#pragma mark get
-(UIWindow *)window
{
    if(_window==nil){
        _window=[[UIApplication sharedApplication] keyWindow];
    }
    return _window;
}
-(NSMutableArray *)firstTypesArr{
    if(_firstTypesArr==nil){
        _firstTypesArr=[NSMutableArray array];
    }
    return _firstTypesArr;
}
-(NSMutableArray *)secondTypesArr{
    if(_secondTypesArr==nil){
        _secondTypesArr=[NSMutableArray array];
    }
    return _secondTypesArr;
}
-(NSMutableArray *)souceArr{
    if(_souceArr==nil){
        _souceArr=[NSMutableArray array];
    }
    return _souceArr;
}
@end
