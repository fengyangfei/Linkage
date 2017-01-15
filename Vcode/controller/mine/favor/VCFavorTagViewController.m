//
//  VCFavorTagViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCFavorTagViewController.h"
#import "SKTagView.h"
#import "VCCategoryUtil.h"

@interface VCFavorTagViewController ()
@property (strong, nonatomic) SKTagView *tagView;
@property (strong, nonatomic) NSArray *titles;

@end

@implementation VCFavorTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTagView];
}

-(void)dealloc
{
    NSLog(@"VCFavorTagViewController -- dealloc");
}

#pragma mark - Private
- (void)setupTagView {
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.backgroundColor = [UIColor whiteColor];
        view.padding = UIEdgeInsetsMake(12, 12, 12, 12);
        view.interitemSpacing = 15;
        view.lineSpacing = 10;
        @weakify(view);
        view.didTapTagAtIndex = ^(NSUInteger index){
            @strongify(view);
            [view removeTagAtIndex:index];
            
            NSString *title = [self.titles objectAtIndex:index];
            SKTag *tag = [SKTag tagWithText: title];
            tag.textColor = [UIColor redColor];
            tag.fontSize = 15;
            tag.borderWidth = 1;
            tag.borderColor = [UIColor redColor];
            tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
            tag.bgColor = [UIColor whiteColor];
            tag.cornerRadius = 5;
            [view insertTag:tag atIndex:index];
        };
        view;
    });
    [self.view addSubview:self.tagView];
    @weakify(self);
    [self.tagView mas_makeConstraints: ^(MASConstraintMaker *make) {
        @strongify(self);
        UIView *superView = self.view;
        make.edges.equalTo(superView);
    }];
    
    [VCCategoryUtil queryAllCategoryTitles:^(NSArray *titles) {
        [titles enumerateObjectsUsingBlock: ^(NSString *text, NSUInteger idx, BOOL *stop) {
            @strongify(self);
            self.titles = titles;
            SKTag *tag = [SKTag tagWithText: text];
            tag.textColor = [UIColor blackColor];
            tag.fontSize = 15;
            tag.borderWidth = 1;
            tag.borderColor = [UIColor blackColor];
            tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
            tag.bgColor = [UIColor whiteColor];
            tag.cornerRadius = 5;
            [self.tagView addTag:tag];
        }];
    }];
}

@end
