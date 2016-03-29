//
//  YGConstants.h
//  TechnologyTemplate
//
//  Created by IcyFenix on 14-11-1.
//  Copyright (c) 2014年 IcyFenix. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "iConsole.h"

#define MAIN_BUNDLE_INFO_DICT [[NSBundle mainBundle] infoDictionary]
//定义应用类型编码
#define MAIN_CODE           [NSString stringWithFormat:@"%@.iOS", MAIN_BUNDLE_INFO_DICT[@"CFBundleIdentifier"]]
//定义应用版本
#define MAIN_VERSION        MAIN_BUNDLE_INFO_DICT[@"CFBundleShortVersionString"]
//定义应用类型与版本号
#define APP_VERSION         [NSString stringWithFormat:@"%@ %@", MAIN_CODE, MAIN_VERSION]
//定义应用程序名称
#define APP_NAME            MAIN_BUNDLE_INFO_DICT[@"CFBundleDisplayName"]?:MAIN_BUNDLE_INFO_DICT[@"CFBundleName"]
//定义系统版本
#define IOS_Version [[[UIDevice currentDevice] systemVersion] floatValue]



#define BIG_FONT_ROW_HEIGHT      64.0
#define SMALL_FONT_ROW_HEIGHT    55.0

#ifdef DEBUG
#define TRACE_LOG             0
#define DEBUG_LOG             0
#define INFO_LOG              1
#define WARN_LOG              1
#define ERROR_LOG             1
#else
#define TRACE_LOG             0
#define DEBUG_LOG             0
#define INFO_LOG              1
#define WARN_LOG              1
#define ERROR_LOG             1
#endif

// 使用16进制定义颜色
#define UIColorFromRGB(rgbValue)                                         \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                    green:((float)((rgbValue & 0x00FF00) >> 8)) / 255.0  \
                     blue:((float)((rgbValue & 0x0000FF) >> 0)) / 255.0  \
                    alpha:1.0]

#define UIColorFromRGBAndAlpha(rgbValue, alphaValue)                     \
    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
                    green:((float)((rgbValue & 0x00FF00) >> 8)) / 255.0  \
                     blue:((float)((rgbValue & 0x0000FF) >> 0)) / 255.0  \
                    alpha:alphaValue]

// 屏蔽调用Selector的内存泄露提示
#define SuppressPerformSelectorLeakWarning(Stuff)                                                                   \
    do {                                                                                                            \
        _Pragma("clang diagnostic push") _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") Stuff; \
        _Pragma("clang diagnostic pop")                                                                             \
    } while (0)

// 抽象方法定义
#define mustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]

//设置颜色
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 全局方法
#define AnonymousWrapper(obj) (obj == nil ? @"匿名用户" : obj)
#define NilStrWrapper(obj) (obj == nil ? @"" : obj)


#ifndef tLog
// trace Log
#if TRACE_LOG
#define tLog(fmt, ...) NSLog(@"TRACE %s(%d) " fmt,__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define tLog(fmt, ...)
#endif
#endif

#ifndef dLog
// debug Log
#if DEBUG_LOG
#define dLog(fmt, ...) NSLog(@"DEBUG %s(%d) " fmt,__PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define dLog(fmt, ...)
#endif
#endif

#ifndef iLog
// info Log
#if INFO_LOG
#define iLog(fmt, ...) [iConsole log:@"INFO  %s(%d) " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]
#else
#define iLog(fmt, ...)
#endif
#endif

#ifndef wLog
// warn Log
#if WARN_LOG
#define wLog(fmt, ...) [iConsole warn:@"WARN  %s(%d) " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]
#else
#define wLog(fmt, ...)
#endif
#endif

#ifndef eLog
// error Log
#if ERROR_LOG
#define eLog(fmt, ...) [iConsole error:@"ERROR %s(%d) " fmt, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]
#else
#define eLog(fmt, ...)
#endif
#endif

//判断设备是否IPHONE5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 667)
#define iPhone6Plus ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width) == 736)


#define IOS(version) ([[[UIDevice currentDevice] systemVersion] floatValue] >= version) // 判断iOS系统版本
#define IOS6 IOS(6.0) // 判断是否是IOS6的系统
#define IOS7 IOS(7.0) // 判断是否是IOS7的系统
#define IOS8 IOS(8.0) // 判断是否是IOS8的系统
#define IOS9 IOS(9.0) // 判断是否是IOS9的系统

//动态获取设备高度
#define MainScreenWidth [UIScreen mainScreen].bounds.size.width
#define MainScreenHeight [UIScreen mainScreen].bounds.size.height
#define IPHONE_HEIGHT MainScreenHeight
#define IPHONE_WIDTH MainScreenWidth

#define IPhoneScreenScale (MainScreenWidth/320) //屏幕相对于iPhone5比例

//设置颜色
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//设置颜色与透明度
#define HEXCOLORAL(rgbValue, al) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:al]

//#define SharedAppDelegate ((YGAppDelegate*)[[UIApplication sharedApplication] delegate])

#define JustWifiDefaultValue ([[NSUserDefaults standardUserDefaults] boolForKey:UserDefault_JustWifiKey])

#define NoPictureModeDefaultValue ([[NSUserDefaults standardUserDefaults] boolForKey:UserDefault_NoPictureModeKey])

//#define SessionDefaultValue ([[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_SessionKey])
//#define SetSessionDefaultValue() ([[NSUserDefaults standardUserDefaults] objectForKey:UserDefault_SessionKey])

// 无网络连接操作
#define NoNetworkConnectionAction SimpleAlert(UIAlertViewStyleDefault, AlertTitle, NoConnectionNetwork, 1000, nil, nil, Confirm)

/**
 * A helper macro to keep the interfaces compatiable with pre ARC compilers.
 * Useful when you put nimbus in a library and link it to a GCC LLVM compiler.
 */

#if defined(__has_feature) && __has_feature(objc_arc_weak)
#define NI_WEAK weak
#define NI_STRONG strong
#elif defined(__has_feature)  && __has_feature(objc_arc)
#define NI_WEAK unsafe_unretained
#define NI_STRONG retain
#else
#define NI_WEAK assign
#define NI_STRONG retain
#endif

#define NSSortDesc(fieldName) [NSSortDescriptor sortDescriptorWithKey:fieldName ascending:NO]
#define NSSortAsc(fieldName) [NSSortDescriptor sortDescriptorWithKey:fieldName ascending:YES]

//定义引用
#define WeakSelf __weak __typeof(self)weakSelf = self;
#define StrongSelf __strong __typeof(weakSelf)strongSelf = weakSelf;

// 单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#undef	DEF_SINGLETON

#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
    static dispatch_once_t once; \
    static __class * __singleton__ = nil; \
    dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
    return __singleton__; \
}

//定义RMMapperModel
#import "RMMapper.h"
#undef	AS_RMMapperModel
#define AS_RMMapperModel( __class ) \
@interface __class (RMMapper) \
+ (instancetype)createFromDictionary:(NSDictionary *)dict; \
+ (NSArray *)createFromArray:(NSArray *)array; \
- (NSDictionary *)dictionaryObject; \
@end

#undef	DEF_RMMapperModel
#define DEF_RMMapperModel( __class ) \
@implementation __class (RMMapper) \
+ (instancetype)createFromDictionary:(NSDictionary *)dict { return [RMMapper objectWithClass:[self class] fromDictionary:dict]; } \
+ (NSArray *)createFromArray:(NSArray *)array { return [RMMapper arrayOfClass:[self class] fromArrayOfDictionary:array]; } \
- (NSDictionary *)dictionaryObject { return [RMMapper dictionaryForObject:self]; } \
@end

#define __PropertyAssociatedKey__(propertyType, setPropertyName) k##propertyType##setPropertyName##Key

//定义Category分类属性
#define __DEF_CategoryProperty__(propertyType, propertyName, setPropertyName, policy, propertyAssociatedKey) \
static const char propertyAssociatedKey; \
- (propertyType)propertyName { \
    return objc_getAssociatedObject(self, &propertyAssociatedKey); \
} \
- (void)set##setPropertyName:(propertyType)propertyName { \
    objc_setAssociatedObject(self, &propertyAssociatedKey, propertyName, policy); \
    if ([self respondsToSelector:@selector(setupDelegateIfNoDelegateSet)]) { \
        [self performSelector:@selector(setupDelegateIfNoDelegateSet)]; \
    } else { \
        if ([self respondsToSelector:@selector(setDelegate:)]) { \
            [self performSelector:@selector(setDelegate:) withObject:self]; \
        } \
    } \
}
#define __DEF_CategoryProperty(propertyType, propertyName, setPropertyName, policy, propertyTypeName) \
__DEF_CategoryProperty__(propertyType, propertyName, setPropertyName, policy, __PropertyAssociatedKey__(propertyTypeName, setPropertyName))

//定义Category分类属性的实现，使用objc/runtime.h，__setProperty设置属性的名称，第一个字母大写且不包含“set”
#undef	DEF_CategoryPropertyRetain
#define DEF_CategoryPropertyRetain(propertyType, propertyName, setPropertyName) \
__DEF_CategoryProperty(propertyType*, propertyName, setPropertyName, OBJC_ASSOCIATION_RETAIN_NONATOMIC, propertyType)


//定义Category分类属性的实现，使用objc/runtime.h，__setProperty设置属性的名称，第一个字母大写且不包含“set”
#undef	DEF_CategoryPropertyWeak
#define DEF_CategoryPropertyWeak(propertyType, propertyName, setPropertyName) \
__DEF_CategoryProperty(propertyType, propertyName, setPropertyName, OBJC_ASSOCIATION_ASSIGN, propertyType)


#undef	DEF_CategoryPropertyAssign
#define DEF_CategoryPropertyAssign(propertyType, propertyName, setPropertyName) \
static const char k##propertyType##setPropertyName##Key; \
- (propertyType)propertyName { \
    return [objc_getAssociatedObject(self, &k##propertyType##setPropertyName##Key) doubleValue]; \
} \
- (void)set##setPropertyName:(propertyType)propertyName { \
    objc_setAssociatedObject(self, &k##propertyType##setPropertyName##Key, @(propertyName), OBJC_ASSOCIATION_ASSIGN); \
}

//定义Category分类的Block属性的实现，使用objc/runtime.h，__blockSetProperty设置属性的名称，第一个字母大写且不包含“set”
#undef	DEF_CategoryPropertyCopy
#define DEF_CategoryPropertyCopy(propertyType, propertyName, setPropertyName) \
__DEF_CategoryProperty(propertyType, propertyName, setPropertyName, OBJC_ASSOCIATION_COPY_NONATOMIC, propertyType)

@interface NSObject (SetDelegate)
- (void) setupDelegateIfNoDelegateSet;
@end

#define NilWrapper(obj) obj == nil ? @"" : obj
#define NilStringWrapper(str) (str == nil || [str isEqual:[NSNull null]]) ? @"" : str

#define ArrNotEmpty(arr) (arr != nil && arr.count > 0)
#define ArrIsEmpty(arr) (arr == nil || arr.count == 0)
#define StringIsNotEmpty(string) (nil!=string && 0 != [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length])
#define StringIsEmpty(string) (nil==string || 0 == [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length])

//当前时间戳，返回以毫秒为单位的当前时间
#define currentTimeMillis (long long)[[NSDate date] timeIntervalSince1970]*1000

//网址正则表达式
#define kHttpOrFtpPattern @"((http[s]{0,1}|ftp)://([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})|((25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]\\d|\\d)\\.){3}(25[0-5]|2[0-4]\\d|1\\d\\d|[1-9]\\d|[1-9]))(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"


#define SP18Font                            [UIFont boldSystemFontOfSize:18.0]      //标题栏，按钮文字
#define SP17Font                            [UIFont systemFontOfSize:17.0]
#define SP16Font                            [UIFont systemFontOfSize:16.0]      //列表，标题，正文
#define SP15Font                            [UIFont systemFontOfSize:15.0]
#define SP14Font                            [UIFont systemFontOfSize:14.0]      //列表，标题，正文(小)
#define SP13Font                            [UIFont systemFontOfSize:13.0]      //注释（消息提示数字，时间等）
#define SP12Font                            [UIFont systemFontOfSize:12.0]      //注释（消息提示数字，时间等）
#define SP11Font                            [UIFont systemFontOfSize:11.0]
#define SP10Font                            [UIFont systemFontOfSize:10.0]

#define AlertTitle @"温馨提示"
#define Cancel @"取消"
#define Confirm @"确定"
#define NoConnectionNetwork @"没有网络连接,请设置后重试"
#define Loading @"加载中..."
#define LoadFailed @"加载失败"
#define SaveFailed @"保存失败"
#define OperationFailure @"操作失败,请重试"
#define OperationSuccess @"操作成功"


#define YGDownLoadIOSAppProtocol @"itms-services://?action=download-manifest&url="
#define YGDownLoadIOSAppUrl(plistUrl) [NSString stringWithFormat:@"%@%@", YGDownLoadIOSAppProtocol, plistUrl]



typedef void(^YGRequestCompletionHandle)(id result, NSError *error);

#ifdef __BLOCKS__
#define dispatch_async_main(block) dispatch_async(dispatch_get_main_queue(), block)
#define dispatch_async_global(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define dispatch_after_main(sec,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec*NSEC_PER_SEC), dispatch_get_main_queue(), block)

#define dispatch_after_global(sec,block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec*NSEC_PER_SEC), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#endif