//
//  AddressWrapper.m
//  Linkage
//
//  Created by lihaijian on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddressWrapper.h"
#import "AddressModel.h"

@interface AddressWrapper()
@property (nonatomic, readonly) AddressModel *model;

@end

@implementation AddressWrapper
@synthesize model = _model;

+(NSArray *)generateAddress:(NSArray *)models
{
    NSMutableArray *array = [NSMutableArray array];
    for (AddressModel *model in models) {
        [array addObject:[[AddressWrapper alloc]initWithModel:model]];
    }
    return [array copy];
}

-(instancetype)initWithModel:(AddressModel *)model
{
    self = [super init];
    if (self) {
        _model = model;
    }
    return self;
}

-(NSString *)phoneNum
{
    return _model.phoneNum;
}

-(NSString *)address
{
    return _model.address;
}

-(BOOL)remove
{
    return [_model remove];
}

@end
