//
//  HGBKeychainTool.m
//  测试
//
//  Created by huangguangbao on 2017/9/15.
//  Copyright © 2017年 agree.com.cn. All rights reserved.
//

#import "HGBKeychainTool.h"

#import <CommonCrypto/CommonCryptor.h>
#import <Security/Security.h>

#ifdef HGBLogFlag
#define HGBLog(FORMAT,...) fprintf(stderr,"**********HGBErrorLog-satrt***********\n{\n文件名称:%s;\n方法:%s;\n行数:%d;\n提示:%s\n}\n**********HGBErrorLog-end***********\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],[[NSString stringWithUTF8String:__func__] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define HGBLog(...);
#endif



static NSString *SFHFKeychainUtilsErrorDomain = @"SFHFKeychainUtilsErrorDomain";

@implementation HGBKeychainTool
#pragma mark keychain

/**
 *  keychain存
 *
 *  @param key   要存的对象的key值
 *  @param value 要保存的value值
 *  @return 保存结果
 */
+ (BOOL)saveKeyChainValue:(id)value withKey:(NSString *)key{
    NSString *string;
    if((!value)||(!key)||key.length==0){
        HGBLog(@"参数不能为空");
        return NO;
    }
    if(!([value isKindOfClass:[NSString class]]||[value isKindOfClass:[NSNumber class]]||[value isKindOfClass:[NSArray class]]||[value isKindOfClass:[NSDictionary class]])){
        HGBLog(@"参数格式不对");
        return NO;
    }else{
        string=[HGBKeychainTool objectEncapsulation:value];
    }
    NSString *bundleid=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    BOOL flag =[HGBKeychainTool storeUsername:key andPassword:string forServiceName:[NSString stringWithFormat:@"%@-llf",bundleid] updateExisting:1 error:nil];
    return flag;
}
/**
 *  keychain取
 *
 *  @param key 对象的key值
 *
 *  @return 获取的对象
 */

+ (id)getKeychainWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        HGBLog(@"key不能为空");
        return nil;
    }
    NSString *bundleid=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];

    NSString *string=[HGBKeychainTool getPasswordForUsername:key andServiceName: [NSString stringWithFormat:@"%@-llf",bundleid] error:nil];

    id value=[HGBKeychainTool stringAnalysis:string];
    return value;
    
}
/**
 *  keychain删除
 *
 *  @param key   要存的对象的key值
 *  @return 保存结果
 */
+ (BOOL)deleteKeyChainWithKey:(NSString *)key{
    if(key==nil||key.length==0){
        HGBLog(@"key不能为空");
        return NO;
    }
    NSString *bundleid=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return [HGBKeychainTool deleteItemForUsername:key andServiceName: [NSString stringWithFormat:@"%@-llf",bundleid] error:nil];
}
#pragma mark object-string
/**
 object编码

 @param object 对象
 @return 编码字符串
 */
+(NSString *)objectEncapsulation:(id)object{
    NSString *string;
    if([object isKindOfClass:[NSString class]]){
        string=object;
    }else if([object isKindOfClass:[NSArray class]]){
        object=[HGBKeychainTool ObjectToJSONString:object];
        string=[@"array://" stringByAppendingString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        object=[HGBKeychainTool ObjectToJSONString:object];
        string=[@"dictionary://" stringByAppendingString:object];
    }else if([object isKindOfClass:[NSNumber class]]){
        string=[NSString stringWithFormat:@"number://%@",object];
    }else{
        string=object;
    }
    return string;
}
/**
 字符串解码

 @param string 字符串
 @return 对象
 */
+(id)stringAnalysis:(NSString *)string{
    id object;
    if([string hasPrefix:@"array://"]){
        string=[string stringByReplacingOccurrencesOfString:@"array://" withString:@""];
        object=[HGBKeychainTool JSONStringToObject:string];
    }else if ([string hasPrefix:@"dictionary://"]){
        string=[string stringByReplacingOccurrencesOfString:@"dictionary://" withString:@""];
        object=[HGBKeychainTool JSONStringToObject:string];
    }else if ([string hasPrefix:@"number://"]){
        string=[string stringByReplacingOccurrencesOfString:@"number://" withString:@""];
        object=[[NSNumber alloc]initWithFloat:string.floatValue];
    }else{
        object=string;
    }
    return object;

}
#pragma mark json
/**
 把Json对象转化成json字符串

 @param object json对象
 @return json字符串
 */
+ (NSString *)ObjectToJSONString:(id)object
{
    if(!([object isKindOfClass:[NSDictionary class]]||[object isKindOfClass:[NSArray class]]||[object isKindOfClass:[NSString class]])){
        return nil;
    }
    if([object isKindOfClass:[NSString class]]){
        return object;
    }
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:object options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return myString;
}
/**
 把Json字符串转化成json对象

 @param jsonString json字符串
 @return json字符串
 */
+ (id)JSONStringToObject:(NSString *)jsonString{
    if(![jsonString isKindOfClass:[NSString class]]){
        return nil;
    }
    jsonString=[HGBKeychainTool jsonStringHandle:jsonString];
    NSError *error = nil;
    NSData  *data=[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if(jsonString.length>0&&[[jsonString substringToIndex:1] isEqualToString:@"{"]){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(error){
            HGBLog(@"%@",error);
            return jsonString;
        }else{
            return dic;
        }
    }else if(jsonString.length>0&&[[jsonString substringToIndex:1] isEqualToString:@"["]){
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        if(error){
            HGBLog(@"%@",error);
            return jsonString;
        }else{
            return array;
        }
    }else{
        return jsonString;
    }


}
/**
 json字符串处理

 @param jsonString 字符串处理
 @return 处理后字符串
 */
+(NSString *)jsonStringHandle:(NSString *)jsonString{
    NSString *string=jsonString;
    //大括号

    //中括号
    while ([string containsString:@"【"]) {
        string=[string stringByReplacingOccurrencesOfString:@"【" withString:@"]"];
    }
    while ([string containsString:@"】"]) {
        string=[string stringByReplacingOccurrencesOfString:@"】" withString:@"]"];
    }

    //小括弧
    while ([string containsString:@"（"]) {
        string=[string stringByReplacingOccurrencesOfString:@"（" withString:@"("];
    }

    while ([string containsString:@"）"]) {
        string=[string stringByReplacingOccurrencesOfString:@"）" withString:@")"];
    }


    while ([string containsString:@"("]) {
        string=[string stringByReplacingOccurrencesOfString:@"(" withString:@"["];
    }

    while ([string containsString:@")"]) {
        string=[string stringByReplacingOccurrencesOfString:@")" withString:@"]"];
    }


    //逗号
    while ([string containsString:@"，"]) {
        string=[string stringByReplacingOccurrencesOfString:@"，" withString:@","];
    }
    while ([string containsString:@";"]) {
        string=[string stringByReplacingOccurrencesOfString:@";" withString:@","];
    }
    while ([string containsString:@"；"]) {
        string=[string stringByReplacingOccurrencesOfString:@"；" withString:@","];
    }
    //引号
    while ([string containsString:@"“"]) {
        string=[string stringByReplacingOccurrencesOfString:@"“" withString:@"\""];
    }
    while ([string containsString:@"”"]) {
        string=[string stringByReplacingOccurrencesOfString:@"”" withString:@"\""];
    }
    while ([string containsString:@"‘"]) {
        string=[string stringByReplacingOccurrencesOfString:@"‘" withString:@"\""];
    }
    while ([string containsString:@"'"]) {
        string=[string stringByReplacingOccurrencesOfString:@"'" withString:@"\""];
    }
    //冒号
    while ([string containsString:@"："]) {
        string=[string stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    }
    //等号
    while ([string containsString:@"="]) {
        string=[string stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    }
    while ([string containsString:@"="]) {
        string=[string stringByReplacingOccurrencesOfString:@"=" withString:@":"];
    }
    return string;

}
#pragma mark 存储于钥匙串

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 30000 && TARGET_IPHONE_SIMULATOR

+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
    if (!username || !serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        return nil;
    }

    SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];

    if (*error || !item) {
        return nil;
    }

    // from Advanced Mac OS X Programming, ch. 16
    UInt32 length;
    char *password;
    SecKeychainAttribute attributes[8];
    SecKeychainAttributeList list;

    attributes[0].tag = kSecAccountItemAttr;
    attributes[1].tag = kSecDescriptionItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
    attributes[3].tag = kSecModDateItemAttr;

    list.count = 4;
    list.attr = attributes;

    OSStatus status = SecKeychainItemCopyContent(item, NULL, &list, &length, (void **)&password);

    if (status != noErr) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        return nil;
    }

    NSString *passwordString = nil;

    if (password != NULL) {
        char passwordBuffer[1024];

        if (length > 1023) {
            length = 1023;
        }
        strncpy(passwordBuffer, password, length);

        passwordBuffer[length] = '\0';
        passwordString = [NSString stringWithCString:passwordBuffer];
    }

    SecKeychainItemFreeContent(&list, password);

    CFRelease(item);

    return passwordString;
}

+ (void) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error {
    if (!username || !password || !serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        return;
    }

    OSStatus status = noErr;

    SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];

    if (*error && [*error code] != noErr) {
        return;
    }

    *error = nil;

    if (item) {
        status = SecKeychainItemModifyAttributesAndData(item,
                                                        NULL,
                                                        strlen([password UTF8String]),
                                                        [password UTF8String]);

        CFRelease(item);
    }
    else {
        status = SecKeychainAddGenericPassword(NULL,
                                               strlen([serviceName UTF8String]),
                                               [serviceName UTF8String],
                                               strlen([username UTF8String]),
                                               [username UTF8String],
                                               strlen([password UTF8String]),
                                               [password UTF8String],
                                               NULL);
    }

    if (status != noErr) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
    }
}

+ (void) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
    if (!username || !serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: 2000 userInfo: nil];
        return;
    }

    *error = nil;

    SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];

    if (*error && [*error code] != noErr) {
        return;
    }

    OSStatus status;

    if (item) {
        status = SecKeychainItemDelete(item);

        CFRelease(item);
    }

    if (status != noErr) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
    }
}

+ (void) purgeItemsForServiceName:(NSString *) serviceName error: (NSError **) error {
    if (!serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: 2000 userInfo: nil];
        return;
    }

    NSMutableDictionary *searchData = [NSMutableDictionary new];
    [searchData setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchData setObject:serviceName forKey:(__bridge id)kSecAttrService];

    OSStatus status = SecItemDelete((__bridge_retained CFDictionaryRef)searchData);

    if (error != nil && status != noErr)
    {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
    }
}

+ (SecKeychainItemRef) getKeychainItemReferenceForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
    if (!username || !serviceName) {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        return nil;
    }

    *error = nil;

    SecKeychainItemRef item;

    OSStatus status = SecKeychainFindGenericPassword(NULL,
                                                     strlen([serviceName UTF8String]),
                                                     [serviceName UTF8String],
                                                     strlen([username UTF8String]),
                                                     [username UTF8String],
                                                     NULL,
                                                     NULL,
                                                     &item);

    if (status != noErr) {
        if (status != errSecItemNotFound) {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        }

        return nil;
    }

    return item;
}

#else

+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
    if (!username || !serviceName) {
        if (error != nil) {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return nil;
    }

    if (error != nil) {
        *error = nil;
    }

    // Set up a query dictionary with the base query attributes: item type (generic), username, and service

    NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass, kSecAttrAccount, kSecAttrService, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword, username, serviceName, nil];

    NSMutableDictionary *query = [[NSMutableDictionary alloc] initWithObjects: objects forKeys: keys];

    // First do a query for attributes, in case we already have a Keychain item with no password data set.
    // One likely way such an incorrect item could have come about is due to the previous (incorrect)
    // version of this code (which set the password as a generic attribute instead of password data).

    NSMutableDictionary *attributeQuery = [query mutableCopy];
    [attributeQuery setObject: (id) kCFBooleanTrue forKey:(__bridge_transfer id) kSecReturnAttributes];
    CFTypeRef attrResult = NULL;
    OSStatus status = SecItemCopyMatching((__bridge_retained CFDictionaryRef) attributeQuery, &attrResult);
    //NSDictionary *attributeResult = (__bridge_transfer NSDictionary *)attrResult;

    if (status != noErr) {
        // No existing item found--simply return nil for the password
        if (error != nil && status != errSecItemNotFound) {
            //Only return an error if a real exception happened--not simply for "not found."
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
        }

        return nil;
    }

    // We have an existing item, now query for the password data associated with it.

    NSMutableDictionary *passwordQuery = [query mutableCopy];
    [passwordQuery setObject: (id) kCFBooleanTrue forKey: (__bridge_transfer id) kSecReturnData];
    CFTypeRef resData = NULL;
    status = SecItemCopyMatching((__bridge_retained CFDictionaryRef) passwordQuery, (CFTypeRef *) &resData);
    NSData *resultData = (__bridge_transfer NSData *)resData;

    if (status != noErr) {
        if (status == errSecItemNotFound) {
            // We found attributes for the item previously, but no password now, so return a special error.
            // Users of this API will probably want to detect this error and prompt the user to
            // re-enter their credentials.  When you attempt to store the re-entered credentials
            // using storeUsername:andPassword:forServiceName:updateExisting:error
            // the old, incorrect entry will be deleted and a new one with a properly encrypted
            // password will be added.
            if (error != nil) {
                *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
            }
        }
        else {
            // Something else went wrong. Simply return the normal Keychain API error code.
            if (error != nil) {
                *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
            }
        }

        return nil;
    }

    NSString *password = nil;

    if (resultData) {
        password = [[NSString alloc] initWithData: resultData encoding: NSUTF8StringEncoding];
    }
    else {
        // There is an existing item, but we weren't able to get password data for it for some reason,
        // Possibly as a result of an item being incorrectly entered by the previous code.
        // Set the -1999 error so the code above us can prompt the user again.
        if (error != nil) {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -1999 userInfo: nil];
        }
    }

    return password;
}

+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error
{
    if (!username || !password || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return NO;
    }

    // See if we already have a password entered for these credentials.
    NSError *getError = nil;
    NSString *existingPassword = [HGBKeychainTool getPasswordForUsername: username andServiceName: serviceName error:&getError];

    if ([getError code] == -1999)
    {
        // There is an existing entry without a password properly stored (possibly as a result of the previous incorrect version of this code.
        // Delete the existing item before moving on entering a correct one.

        getError = nil;

        [self deleteItemForUsername: username andServiceName: serviceName error: &getError];

        if ([getError code] != noErr)
        {
            if (error != nil)
            {
                *error = getError;
            }
            return NO;
        }
    }
    else if ([getError code] != noErr)
    {
        if (error != nil)
        {
            *error = getError;
        }
        return NO;
    }

    if (error != nil)
    {
        *error = nil;
    }

    OSStatus status = noErr;

    if (existingPassword)
    {
        // We have an existing, properly entered item with a password.
        // Update the existing item.

        if (![existingPassword isEqualToString:password] && updateExisting)
        {
            //Only update if we're allowed to update existing.  If not, simply do nothing.

            NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass,
                             kSecAttrService,
                             kSecAttrLabel,
                             kSecAttrAccount,
                             nil];

            NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword,
                                serviceName,
                                serviceName,
                                username,
                                nil];

            NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];

            status = SecItemUpdate((__bridge_retained CFDictionaryRef) query, (__bridge_retained CFDictionaryRef) [NSDictionary dictionaryWithObject: [password dataUsingEncoding: NSUTF8StringEncoding] forKey: (__bridge_transfer NSString *) kSecValueData]);
        }
    }
    else
    {
        // No existing entry (or an existing, improperly entered, and therefore now
        // deleted, entry).  Create a new entry.

        NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass,
                         kSecAttrService,
                         kSecAttrLabel,
                         kSecAttrAccount,
                         kSecValueData,
                         nil];

        NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword,
                            serviceName,
                            serviceName,
                            username,
                            [password dataUsingEncoding: NSUTF8StringEncoding],
                            nil];

        NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];

        status = SecItemAdd((__bridge_retained CFDictionaryRef) query, NULL);
    }

    if (error != nil && status != noErr)
    {
        // Something went wrong with adding the new item. Return the Keychain error code.
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];

        return NO;
    }

    return YES;
}

+ (BOOL) deleteItemForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error
{
    if (!username || !serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return NO;
    }

    if (error != nil)
    {
        *error = nil;
    }

    NSArray *keys = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClass, kSecAttrAccount, kSecAttrService, kSecReturnAttributes, nil];
    NSArray *objects = [[NSArray alloc] initWithObjects: (__bridge_transfer NSString *) kSecClassGenericPassword, username, serviceName, kCFBooleanTrue, nil];

    NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];

    OSStatus status = SecItemDelete((__bridge_retained CFDictionaryRef) query);

    if (error != nil && status != noErr)
    {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];

        return NO;
    }

    return YES;
}

+ (BOOL) purgeItemsForServiceName:(NSString *) serviceName error: (NSError **) error {
    if (!serviceName)
    {
        if (error != nil)
        {
            *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
        }
        return NO;
    }

    if (error != nil)
    {
        *error = nil;
    }

    NSMutableDictionary *searchData = [NSMutableDictionary new];
    [searchData setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchData setObject:serviceName forKey:(__bridge id)kSecAttrService];

    OSStatus status = SecItemDelete((__bridge_retained CFDictionaryRef)searchData);

    if (error != nil && status != noErr)
    {
        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];

        return NO;
    }

    return YES;
}

#endif

@end
