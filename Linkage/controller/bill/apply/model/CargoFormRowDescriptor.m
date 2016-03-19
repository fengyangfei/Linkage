//
//  CargoFormRowDescriptor.m
//  Linkage
//
//  Created by lihaijian on 16/3/19.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CargoFormRowDescriptor.h"
#import "CargoModel.h"

@implementation CargoFormRowDescriptor

- (void)dealloc
{
    @try {
        [self removeObserver:self forKeyPath:@"value.cargoType"];
    }
    @catch (NSException * __unused exception) {}
}

-(instancetype)initWithTag:(NSString *)tag rowType:(NSString *)rowType title:(NSString *)title;
{
    self = [super initWithTag:tag rowType:rowType title:title];
    if (self) {
        [self addObserver:self forKeyPath:@"value.cargoType" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:0];
    }
    return self;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    if (object == self && ([keyPath isEqualToString:@"value.cargoType"])){
        if ([[change objectForKey:NSKeyValueChangeKindKey] isEqualToNumber:@(NSKeyValueChangeSetting)]){
            CargoModel *newValue = [change objectForKey:NSKeyValueChangeNewKey];
            CargoModel *oldValue = [change objectForKey:NSKeyValueChangeNewKey];
            if ([keyPath isEqualToString:@"value.cargoType"]){
                if (self.onChangeBlock) {
                    self.onChangeBlock(oldValue, newValue, self);
                }
            }
        }
    }
}

@end
