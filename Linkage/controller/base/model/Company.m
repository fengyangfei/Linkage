//
//  Company.m
//  Linkage
//
//  Created by lihaijian on 16/3/25.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Company.h"
#define kUserDefalutCompanyKey  @"kUserDefalutCompanyKey"

@implementation Company

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.logo forKey:logo];
    [aCoder encodeObject:self.companyName forKey:companyName];
    [aCoder encodeObject:self.introduction forKey:introduction];
    [aCoder encodeObject:self.contract forKey:contract];
    [aCoder encodeObject:self.address forKey:address];
    [aCoder encodeObject:self.email forKey:email];
    [aCoder encodeObject:self.fax forKey:fax];
    [aCoder encodeObject:self.url forKey:url];
    [aCoder encodeObject:self.companyImages forKey:companyImages];
    [aCoder encodeObject:self.customerPhones forKey:customerPhones];
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.logo = [aDecoder decodeObjectForKey:logo];
        self.companyName = [aDecoder decodeObjectForKey:companyName];
        self.introduction = [aDecoder decodeObjectForKey:introduction];
        self.contract = [aDecoder decodeObjectForKey:contract];
        self.address = [aDecoder decodeObjectForKey:address];
        self.email = [aDecoder decodeObjectForKey:email];
        self.fax = [aDecoder decodeObjectForKey:fax];
        self.url = [aDecoder decodeObjectForKey:url];
        self.companyImages = [aDecoder decodeObjectForKey:companyImages];
        self.customerPhones = [aDecoder decodeObjectForKey:customerPhones];
    }
    return self;
}

- (NSArray *)rm_excludedProperties
{
    return @[@"photos"];
}

//保存
static Company *company;
-(BOOL)save
{
    company = self;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kUserDefalutCompanyKey];
    return [[NSUserDefaults standardUserDefaults] synchronize];
}

+(Company *)shareInstance
{
    if (!company) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefalutCompanyKey];
        if(data){
            company = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
    }
    return company;
}

@end
DEF_RMMapperModel(Company)
