//
//  FavoriteViewController.m
//  Linkage
//
//  Created by lihaijian on 16/3/24.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "FavoriteViewController.h"
#import "FavoriteUtil.h"
#import "FavoriteViewController.h"

@implementation FavoriteViewController

-(Class)modelUtilClass
{
    return [FavoriteUtil class];
}

-(Class)viewControllerClass
{
    return [FavoriteViewController class];
}

@end
