//
//  NSString+HGBStringTypeCheck.m
//  测试app
//
//  Created by huangguangbao on 2017/6/30.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "NSString+HGBStringTypeCheck.h"


#ifdef HGBLogFlag
#define HGBLog(FORMAT,...) fprintf(stderr,"**********HGBErrorLog-satrt***********\n{\n文件名称:%s;\n方法:%s;\n行数:%d;\n提示:%s\n}\n**********HGBErrorLog-end***********\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],[[NSString stringWithUTF8String:__func__] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define HGBLog(...);
#endif


@implementation NSString (HGBStringTypeCheck)
/**
 *  验证字符是否是数字
 *
 *  @return  结果
 */
-(BOOL)isNumString{
    NSString *idStr=@"^[0-9]+$";
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idStr];
    
    if([regextestmobile evaluateWithObject:self]==YES){
        return YES;
    }else{
        return NO;
    }
}


/**
 *  验证字符是否是字母
 *
 *  @return  结果
 */
-(BOOL)isWordString{
    NSString *idStr=@"^[A-Za-z]+$";;
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idStr];
    
    if([regextestmobile evaluateWithObject:self]==YES){
        return YES;
    }else{
        return NO;
    }
}
/**
 *  验证字符是否是汉字
 *
 *  @return  结果
 */
-(BOOL)isChineseString{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
/**
 *  检验字符是否是字母或数字
 *
 *  @return 字符串合法性
 */
-(BOOL)isNumOrWordString
{
    NSString *idStr=@"^[A-Za-z0-9]+$";
    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",idStr];
    
    if([regextestmobile evaluateWithObject:self]==YES){
        return YES;
    }else{
        return NO;
    }
}
@end
