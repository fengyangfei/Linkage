//
//  Address.m
//  Linkage
//
//  Created by Mac mini on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Address.h"

#define kUserDefalutAddressKey  @"kUserDefalutAddressKey"

@implementation Address

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.phoneNum forKey:phoneNum];
    [aCoder encodeObject:self.address forKey:address];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.phoneNum = [aDecoder decodeObjectForKey:phoneNum];
        self.address = [aDecoder decodeObjectForKey:address];
    }
    return self;
}

-(BOOL)save
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefalutAddressKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(Address *)defaultAddress
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefalutAddressKey];
    if(data){
        return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    return nil;
}

-(BOOL)remove
{
    return NO;
}

@end
