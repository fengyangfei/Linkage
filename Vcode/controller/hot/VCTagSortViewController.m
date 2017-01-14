//
//  VCTagSortViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/14.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCTagSortViewController.h"
#import "VCSortTagView.h"

@interface VCTagSortViewController ()
@property (nonatomic, readonly) VCSortTagView *tagView;

@end

@implementation VCTagSortViewController
@synthesize tagView = _tagView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tagView];
    [self.tagView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(VCSortTagView *)tagView
{
    if (!_tagView) {
        CGRect rect = self.view.bounds;
        _tagView = [[VCSortTagView alloc]initWithFrame:rect];
    }
    return _tagView;
}

@end
