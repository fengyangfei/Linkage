//
//  AddressViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/21.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AddressViewController.h"
#import "AddressUtil.h"
#import "AddAddressViewController.h"

@implementation AddressViewController

-(Class)modelUtilClass
{
    return [AddressUtil class];
}

-(Class)viewControllerClass
{
    return [AddAddressViewController class];
}
@end