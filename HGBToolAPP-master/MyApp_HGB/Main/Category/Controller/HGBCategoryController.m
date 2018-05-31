
//
//  HGBCategoryController.m
//  MyApp_HGB
//
//  Created by huangguangbao on 2018/4/4.
//  Copyright © 2018年 agree.com.cn. All rights reserved.
//

#import "HGBCategoryController.h"

#import "HGBCommonShowCell.h"
#import "HGBFunctionModel.h"

#define kWidth [[UIScreen mainScreen] bounds].size.width
#define kHeight [[UIScreen mainScreen] bounds].size.height

//屏幕比例
#define wScale kWidth / 750.0
#define hScale kHeight / 1334.0

#define Identify_Cell @"cell"

@interface HGBCategoryController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UIScrollViewDelegate>
/**
 表格
 */
@property(strong,nonatomic)UITableView *tableView;
/**
 全部数据源
 */
@property(strong,nonatomic)NSDictionary *dataDic;
/**
 全部数据源
 */
@property(strong,nonatomic)NSDictionary *allDic;
/**
 分类数据源
 */
@property(strong,nonatomic)NSMutableArray *keys;
/**
 分类数据源
 */
@property(strong,nonatomic)NSMutableArray *allKeys;
/**
 本组数据源
 */
@property(strong,nonatomic)NSMutableArray *items;
/**
 搜索框
 */
@property(strong,nonatomic)UISearchBar *searchBar;
@end

@implementation HGBCategoryController

#pragma mark life
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationItem];//导航栏
    [self viewSetUp];//UI
    self.view.backgroundColor=[UIColor colorWithRed:245.0/256 green:242.0/256 blue:242.0/256 alpha:1];

}
#pragma mark 导航栏
//导航栏
-(void)createNavigationItem
{
    //搜索框

    UIView *navBar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 64)];

    navBar.backgroundColor=[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1];
    [self.view addSubview:navBar];
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(30*wScale, 20, self.view.bounds.size.width-60*wScale, 44)];
    self.searchBar=searchBar;
    searchBar.enablesReturnKeyAutomatically = YES;
    searchBar.tintColor=[UIColor whiteColor];
    searchBar.barTintColor=[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1];
    searchBar.placeholder=@"输入搜索内容";
    //不显示取消按钮
    searchBar.showsCancelButton=NO;
    searchBar.delegate=self;


    searchBar.layer.borderColor =[[UIColor colorWithRed:0.0/256 green:191.0/256 blue:256.0/256 alpha:1] CGColor];
    searchBar.layer.borderWidth = 1;
    searchBar.returnKeyType=UIReturnKeySearch;
    [navBar addSubview:searchBar];

//    UIButton *searchButton=[UIButton buttonWithType:(UIButtonTypeCustom)];
//    [searchButton setImage:[UIImage imageNamed:@"icon_search"] forState:(UIControlStateNormal)];
//    searchButton.frame=CGRectMake(kWidth-40-30*wScale, 25, 40, 40);
//    [searchButton addTarget:self action:@selector(searchButtonAction:) forControlEvents:(UIControlEventTouchUpInside)];
//    [navBar addSubview:searchButton];







}
//返回
-(void)returnhandler{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)searchButtonAction:(UIButton *)_b{
    NSString *search=self.searchBar.text;
    if(search==nil||search.length==0){
        self.searchBar.showsCancelButton=NO;
        self.dataDic = self.allDic;
        self.keys=self.allKeys;

    }else{
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        NSArray *keys=[self.allDic allKeys];
        self.keys=[NSMutableArray array];
        for (NSString *key in keys) {
            NSArray *array=self.allDic[key];
            NSMutableArray *items=[NSMutableArray array];
            for(int i=0;i<array.count;i++){
                NSDictionary *itemDic=array[i];
                HGBFunctionModel *item=[HGBFunctionModel functionModelWithDictionary:itemDic];
                if([item.page containsString:search]||[item.name containsString:search]){
                    [items addObject:itemDic];
                    for(HGBFunctionModel *model in self.allKeys){
                        if([model.page isEqualToString:key]){
                            [self.keys addObject:model];
                        }

                    }
                }
            }

            [dic setObject:items forKey:key];
        }
        self.dataDic=dic;


    }
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
    if(search.length!=0){
       self.searchBar.showsCancelButton=YES;
    }else{
       self.searchBar.showsCancelButton=NO;
    }

}
//文本改变
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *search=searchBar.text;
    if(search==nil||search.length==0||(![search isKindOfClass:[NSString class]])){
        self.dataDic = self.allDic;
        self.keys=self.allKeys;
    }else{
        NSMutableDictionary *dic=[NSMutableDictionary dictionary];
        NSArray *keys=[self.allDic allKeys];
        self.keys=[NSMutableArray array];
        for (NSString *key in keys) {
            NSArray *array=self.allDic[key];
            NSMutableArray *items=[NSMutableArray array];
            for(int i=0;i<array.count;i++){
                NSDictionary *itemDic=array[i];
                HGBFunctionModel *item=[HGBFunctionModel functionModelWithDictionary:itemDic];
                if([item.page containsString:search]||[item.name containsString:search]){
                    [items addObject:itemDic];
                    for(HGBFunctionModel *model in self.allKeys){
                        if([model.page isEqualToString:key]){
                            [self.keys addObject:model];
                        }

                    }
                }
            }

            [dic setObject:items forKey:key];
        }
        self.dataDic=dic;


    }
    [self.tableView reloadData];
    if(search.length!=0){
        searchBar.showsCancelButton=YES;
    }else{
        searchBar.showsCancelButton=NO;
    }

}
//取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if(searchBar.text.length!=0){
        searchBar.showsCancelButton=YES;
    }else{
        searchBar.showsCancelButton=NO;
    }
    searchBar.text=@"";


    //搜索
    [self searchBar:searchBar textDidChange:searchBar.text];
    [searchBar resignFirstResponder];



}

//搜索按钮
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(searchBar.text.length!=0){
        searchBar.showsCancelButton=YES;
    }else{
        searchBar.showsCancelButton=NO;
    }
    [searchBar resignFirstResponder];
    //搜索
    [self searchBar:searchBar textDidChange:searchBar.text];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if(searchBar.text.length!=0){
        searchBar.showsCancelButton=YES;
    }else{
        searchBar.showsCancelButton=NO;
    }
    return YES;
}
//结束编辑
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if(searchBar.text.length!=0){
        searchBar.showsCancelButton=YES;
    }else{
        searchBar.showsCancelButton=NO;
    }

    return YES;
}
#pragma mark scroller
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}
#pragma mark UI
/**
 UI
 */
-(void)viewSetUp{
    self.view.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,70, kWidth, kHeight-70) style:(UITableViewStylePlain)];
    self.tableView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    

    [self.tableView registerClass:[HGBCommonShowCell class] forCellReuseIdentifier:Identify_Cell];
    [self.tableView reloadData];


}
#pragma mark tableDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.keys.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HGBFunctionModel *model=self.keys[section];
    NSArray *items=[self.dataDic objectForKey:model.page];
    return items.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 53;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 72*hScale;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HGBFunctionModel *model=self.keys[section];
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 72 * hScale)];
    headView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];

    UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(30*hScale, 15*hScale, 42*wScale, 42*hScale)];
    imgV.image=[UIImage imageNamed:model.image];
    [headView addSubview:imgV];

    //信息提示栏
    UILabel *tipMessageLabel = [[UILabel alloc]initWithFrame:CGRectMake(80 * wScale, 0, kWidth - 110 * wScale, CGRectGetHeight(headView.frame))];
    tipMessageLabel.backgroundColor = [UIColor clearColor];
    tipMessageLabel.text =model.name;
    tipMessageLabel.textColor = [UIColor grayColor];
    tipMessageLabel.textAlignment = NSTextAlignmentLeft;
    tipMessageLabel.font = [UIFont systemFontOfSize:12.0];
    tipMessageLabel.numberOfLines = 0;
    [headView addSubview:tipMessageLabel];
    return headView;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HGBCommonShowCell *cell=[tableView dequeueReusableCellWithIdentifier:Identify_Cell forIndexPath:indexPath];
    HGBFunctionModel *model=self.keys[indexPath.section];
    NSArray *array=[self.dataDic objectForKey:model.page];
    NSMutableArray *items=[NSMutableArray array];
    for (NSDictionary *dic in array) {
        HGBFunctionModel *item=[HGBFunctionModel functionModelWithDictionary:dic];
        if(![item.page isEqualToString:@"detail"]){
            [items addObject:item];
        }

    }
    HGBFunctionModel *item=items[indexPath.row];
    cell.imgV.image=[UIImage imageNamed:item.image];
    cell.title.text=item.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    HGBFunctionModel *model=self.keys[indexPath.section];
    NSArray *array=[self.dataDic objectForKey:model.page];
    NSMutableArray *items=[NSMutableArray array];
    for (NSDictionary *dic in array) {
        HGBFunctionModel *item=[HGBFunctionModel functionModelWithDictionary:dic];
        if(![item.page isEqualToString:@"detail"]){
            [items addObject:item];
        }

    }
    HGBFunctionModel *item=items[indexPath.row];
    if (item.page&&item.page.length!=0) {
        UIViewController *controller=(UIViewController *)[[NSClassFromString(item.page) alloc]init];
        [self presentController:controller];
    }
}
#pragma mark 弹出
-(void)presentController:(UIViewController*)controller{
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark get
-(NSDictionary *)dataDic{
    if(_dataDic==nil){


        _dataDic=self.allDic;
        if (_dataDic==nil) {
            _dataDic=[NSDictionary dictionary];
        }
    }
    return _dataDic;
}
-(NSDictionary *)allDic{
    if(_allDic==nil){
        NSString *parh=[[NSBundle mainBundle]pathForResource:@"HGBFuntion" ofType:@"plist"];
        _allDic=[NSDictionary dictionaryWithContentsOfFile:parh];
        if (_allDic==nil) {
            _allDic=[NSDictionary dictionary];
        }
    }
    return _allDic;
}

#pragma mark get
-(NSMutableArray *)items{
    if(_items==nil){
        _items=[NSMutableArray array];

    }
    return _items;
}
-(NSMutableArray *)allKeys{
    if(_allKeys==nil){
        _allKeys=[NSMutableArray array];
        NSString *parh=[[NSBundle mainBundle]pathForResource:@"HGBFuncionType" ofType:@"plist"];
        NSArray *array=[NSArray arrayWithContentsOfFile:parh];
        for (NSDictionary *dic in array) {
            HGBFunctionModel *item=[HGBFunctionModel functionModelWithDictionary:dic];
            if(![item.page isEqualToString:@"detail"]){
                [_allKeys addObject:item];
            }

        }
    }
    return _allKeys;
}
-(NSMutableArray *)keys{
    if(_keys==nil){
        _keys=self.allKeys;
    }
    return _keys;
}

@end
