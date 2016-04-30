//
//  StaffViewController.m
//  Linkage
//
//  Created by lihaijian on 16/4/30.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "StaffViewController.h"
#import "StaffUtil.h"
#import "StaffViewController.h"

@implementation StaffViewController

-(Class)modelUtilClass
{
    return [StaffUtil class];
}

-(Class)viewControllerClass
{
    return [StaffViewController class];
}
@end
