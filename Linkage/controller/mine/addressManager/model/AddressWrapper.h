//
//  AddressWrapper.h
//  Linkage
//
//  Created by lihaijian on 16/3/23.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "Address.h"
@class AddressModel;
@interface AddressWrapper : Address
+(NSArray *)generateAddress:(NSArray *)models;
-(instancetype)initWithModel:(AddressModel *)model;
@end
