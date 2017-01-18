//
//  VCFavorTagViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCFavorTagViewController.h"
#import "SKTagView.h"
#import "VCCategory.h"
#import "VCCategoryUtil.h"
#import "VcodeUtil.h"

@interface VCFavorTagViewController ()
@property (strong, nonatomic) SKTagView *tagView;
@property (strong, nonatomic) NSMutableArray *categories;

@end

@implementation VCFavorTagViewController
@synthesize categories = _categories;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTagView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:VCThemeString(@"ok") style:UIBarButtonItemStylePlain target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = BackgroundColor;

}

-(void)dealloc
{
    NSLog(@"VCFavorTagViewController -- dealloc");
}

#pragma mark - Private
- (void)setupTagView {
    @weakify(self);
    self.tagView = ({
        SKTagView *view = [SKTagView new];
        view.backgroundColor = [UIColor whiteColor];
        view.padding = UIEdgeInsetsMake(12, 12, 12, 12);
        view.interitemSpacing = 15;
        view.lineSpacing = 10;
        @weakify(view);
        view.didTapTagAtIndex = ^(NSUInteger index){
            @strongify(view);
            @strongify(self);
            [view removeTagAtIndex:index];
            VCCategory *category = [self.categories objectAtIndex:index];
            category.favor = !category.favor;
            if (category.favor) {
                [view insertTag:[self createHightLightTag:category.title] atIndex:index];
            }else{
                [view insertTag:[self createNormalTag:category.title] atIndex:index];
            }
            [VCCategoryUtil getModelByCode:category.code completion:^(VCCategory * model) {
                model.favor = !model.favor;
                [VCCategoryUtil syncToDataBase:model completion:^{
                }];
            }];
        };
        view;
    });
    [self.view addSubview:self.tagView];
    [self.tagView mas_makeConstraints: ^(MASConstraintMaker *make) {
        @strongify(self);
        UIView *superView = self.view;
        make.edges.equalTo(superView);
    }];
    [VCCategoryUtil queryAllCategories:^(NSArray *models) {
        @strongify(self);
        [self.categories removeAllObjects];
        [self.categories addObjectsFromArray:models];
        for (VCCategory *category in models) {
            if (!category.favor) {
                [self.tagView addTag:[self createNormalTag:category.title]];
            }else{
                [self.tagView addTag:[self createHightLightTag:category.title]];
            }
        }
    }];
}

-(void)doneAction:(id)sender
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
        
    }];
    /*
    [VCCategoryUtil getFavorCategories:^(NSArray *models) {
        NSDictionary *parameter = @{@"deviceCode":[VcodeUtil UUID], @"url": @""};
        [[YGRestClient sharedInstance] postForObjectWithUrl:AddVisitRecordUrl form:parameter success:^(id responseObject) {
            NSLog(@"%@",responseObject);
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    }];*/
}

-(SKTag *)createNormalTag:(NSString *)text
{
    SKTag *tag = [SKTag tagWithText: text];
    tag.textColor = [UIColor blackColor];
    tag.fontSize = 15;
    tag.borderWidth = 1;
    tag.borderColor = [UIColor blackColor];
    tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
    tag.bgColor = [UIColor whiteColor];
    tag.cornerRadius = 5;
    return tag;
}

-(SKTag *)createHightLightTag:(NSString *)text
{
    SKTag *tag = [SKTag tagWithText:text];
    tag.textColor = [UIColor whiteColor];
    tag.fontSize = 15;
    //tag.borderWidth = 1;
    //tag.borderColor = [UIColor redColor];
    tag.bgColor = VHeaderColor;
    tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
    tag.cornerRadius = 5;
    return tag;
}

-(NSMutableArray *)categories
{
    if (!_categories) {
        _categories = [[NSMutableArray alloc]init];
    }
    return _categories;
}

@end
