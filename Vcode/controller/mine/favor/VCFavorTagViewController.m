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
@property (strong, nonatomic) NSArray *colors;

@end

@implementation VCFavorTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.colors = @[HEXCOLOR(0x7ecef4), HEXCOLOR(0x84ccc9), HEXCOLOR(0x88abda), HEXCOLOR(0x7dc1dd), HEXCOLOR(0xb6b8de)];
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
        __weak SKTagView *weakView = view;
        view.didTapTagAtIndex = ^(NSUInteger index){
            [weakView removeTagAtIndex:index];
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
            SKTag *tag = [SKTag tagWithText: text];
            tag.textColor = [UIColor whiteColor];
            tag.fontSize = 15;
            //tag.font = [UIFont fontWithName:@"Courier" size:15];
            //tag.enable = NO;
            tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
            tag.bgColor = self.colors[idx % self.colors.count];
            tag.cornerRadius = 5;
            [self.tagView addTag:tag];
        }];
    }];
}

@end
