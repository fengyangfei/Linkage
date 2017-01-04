//
//  VCCountryViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/4.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCCountryViewController.h"
#import "VCCountryUtil.h"

@interface VCCountryViewController ()

@end

@implementation VCCountryViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.options = [VCCountryUtil queryAllCountrys];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
