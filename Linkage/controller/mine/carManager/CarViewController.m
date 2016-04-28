//
//  CarViewController.m
//  Linkage
//
//  Created by Mac mini on 16/4/28.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CarViewController.h"
#import "CarUtil.h"
#import "AddCarViewController.h"

@interface CarViewController ()

@end

@implementation CarViewController

-(Class)modelUtilClass
{
    return [CarUtil class];
}

-(Class)viewControllerClass
{
    return [AddCarViewController class];
}
@end
