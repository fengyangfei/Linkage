//
//  NSString+PingYinChar.m
//  Linkage
//
//  Created by lihaijian on 2017/1/18.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "NSString+PingYinChar.h"

@implementation NSString (PingYinChar)
- (NSString *) pinyin
{
    NSMutableString *str = [self mutableCopy];
    //转拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //去音标
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

//返回拼音首字母字符串
- (NSString *) pinyinInitial
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    
    return initial;
}
@end
