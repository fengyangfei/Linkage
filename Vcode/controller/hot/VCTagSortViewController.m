//
//  VCTagSortViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/14.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCTagSortViewController.h"
#import "VCSortTagView.h"

@interface VCTagSortViewController ()<VCSortTagViewDelegate>
@property (nonatomic, readonly) VCSortTagView *tagView;

@end

@implementation VCTagSortViewController
@synthesize tagView = _tagView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑排序";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tagView];
    [self.tagView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - VCSortTagViewDelegate
- (void)VCSortTagViewRefresh:(VCSortTagView *)gridView
{
    if ([self.delegate respondsToSelector:@selector(refreshTag)]) {
        [self.delegate refreshTag];
    }
}

#pragma mark - getter
-(VCSortTagView *)tagView
{
    if (!_tagView) {
        CGRect rect = self.view.bounds;
        _tagView = [[VCSortTagView alloc] initWithFrame:rect];
        _tagView.delegate = self;
    }
    return _tagView;
}

@end
