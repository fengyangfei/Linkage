//
//  VCWebBrowserViewController.m
//  Linkage
//
//  Created by lihaijian on 2017/1/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCWebBrowserViewController.h"
#import "VCFavor.h"
#import "VCFavorModel.h"
#import "VCFavorUtil.h"
#import "VCPageUtil.h"
#import "VCIndex.h"
#import "MMAlertView.h"

@interface VCWebBrowserViewController ()
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, readonly) UIButton *favorInnerButton;
@property (nonatomic, readonly) UIBarButtonItem *starButton;
@property (nonatomic, strong) UIBarButtonItem *rocketButton;
@property (nonatomic, strong) UIBarButtonItem *favorButton;
@property (nonatomic) BOOL favorStatus;
@end

@implementation VCWebBrowserViewController
@synthesize favorButton = _favorButton;
@synthesize starButton = _starButton;
@synthesize rocketButton = _rocketButton;
@synthesize favorInnerButton = _favorInnerButton;

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(void)setupData
{
    @weakify(self);
    if(self.wkWebView) {
        self.urlStr = self.wkWebView.URL.absoluteString;
        [VCFavorUtil getModelByUrl:self.urlStr completion:^(id<MTLJSONSerializing> model) {
            @strongify(self);
            if (model) {
                self.favorStatus = YES;
            }else{
                self.favorStatus = NO;
            }
        }];
        [RACObserve(self, favorStatus) subscribeNext:^(id x) {
            if ([x boolValue]) {
                UIImage *likeOffIcon = [UIImage imageNamed:@"like_icon_on"];
                [self.favorInnerButton setImage:likeOffIcon forState:UIControlStateNormal];
                [self.favorButton setImage:likeOffIcon];
            }else{
                UIImage *likeOffIcon = [UIImage imageNamed:@"like_icon_off"];
                [self.favorInnerButton setImage:likeOffIcon forState:UIControlStateNormal];
                [self.favorButton setImage:likeOffIcon];
            }
        }];
    }
}

-(NSArray *)bottomBarItems
{
    NSArray *barButtonItems = [super bottomBarItems];
    
    UIBarButtonItem *fixedSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSeparator.width = 50.0f;
    UIBarButtonItem *flexibleSeparator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    //自定按钮（收藏与加速按钮）
    NSMutableArray *mutableBarButtonItems = [NSMutableArray arrayWithArray:barButtonItems];
    [mutableBarButtonItems addObjectsFromArray:@[flexibleSeparator, self.favorButton, flexibleSeparator, self.starButton, flexibleSeparator, self.rocketButton]];
    barButtonItems = [NSArray arrayWithArray:mutableBarButtonItems];
    return barButtonItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 事件处理
//添加到标签
-(void)starButtonPressed:(id)sender
{
    [self saveStar:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kPageUpdateNotification object:nil];
    }];
}

- (void)saveStar:(void(^)(void))completion
{
    NSString *title;
    if(self.wkWebView) {
        title = self.wkWebView.title;
        self.urlStr = self.wkWebView.URL.absoluteString;
    }
    else if(self.uiWebView) {
        title = [self.uiWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    VCPage *page = [[VCPage alloc]init];
    page.name = title;
    page.url = self.urlStr;
    page.sortNumber = @(-1);
    
    [VCPageUtil syncToDataBase:page completion:^{
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
            if (completion) {
                completion();
            }
        }];
    }];
}

- (void)deleteStar:(void(^)(void))completion
{
    [VCPageUtil getModelByUrl:self.urlStr completion:^(id<MTLJSONSerializing> model) {
        [VCFavorUtil syncToDataBase:model completion:^{
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                if (completion) {
                    completion();
                }
            }];
        }];
    }];
}

//添加到收藏
- (void)likeButtonPressed:(id)sender {
    @weakify(self);
    if(!self.favorStatus){
        NSString *title;
        if(self.wkWebView) {
            title = self.wkWebView.title;
            self.urlStr = self.wkWebView.URL.absoluteString;
        }
        else if(self.uiWebView) {
            title = [self.uiWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
        }
        
        MMAlertView *alertView = [[MMAlertView alloc] initWithInputTitle:@"是否添加到收藏？" detail:@"" inputText:title placeholder:@"自定义标题" handler:^(NSString *text) {
            @strongify(self);
            VCFavor *favor = [[VCFavor alloc]init];
            favor.title = text;
            favor.url = self.urlStr;
            favor.createdDate = [NSDate date];
            @weakify(self);
            [self saveFavor:favor completion:^{
                @strongify(self);
                self.favorStatus = YES;
            }];
        }];
        alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
        alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
        [alertView show];
    }else{
        [self deleteFavor:^{
            @strongify(self);
            self.favorStatus = NO;
        }];
    }
}

- (void)saveFavor:(VCFavor *)favor completion:(void(^)(void))completion
{
    [VCFavorUtil syncToDataBase:favor completion:^{
        [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
            if (completion) {
                completion();
            }
        }];
    }];
}

- (void)deleteFavor:(void(^)(void))completion
{
    [VCFavorUtil getModelByUrl:self.urlStr completion:^(id<MTLJSONSerializing> model) {
        [VCFavorUtil syncToDataBase:model completion:^{
            [[NSManagedObjectContext MR_defaultContext] MR_saveWithOptions:MRSaveParentContexts | MRSaveSynchronously completion:^(BOOL contextDidSave, NSError * error) {
                if (completion) {
                    completion();
                }
            }];
        }];
    }];
}

#pragma mark - KINWebBrowserDelegate
- (void)webBrowser:(KINWebBrowserViewController *)webBrowser didStartLoadingURL:(NSURL *)URL
{
    self.urlStr = URL.absoluteString;
}

#pragma mark - getter setter
-(UIBarButtonItem *)favorButton
{
    if (!_favorButton) {
        _favorButton = [[UIBarButtonItem alloc]initWithCustomView:self.favorInnerButton];
        UIImage *likeOffIcon = [UIImage imageNamed:@"like_icon_off"];

        //_favorButton = [ui]
        _favorButton = [[UIBarButtonItem alloc] initWithImage:likeOffIcon style:UIBarButtonItemStylePlain target:self action:@selector(likeButtonPressed:)];
    }
    return _favorButton;
}

-(UIBarButtonItem *)starButton
{
    if (!_starButton) {
        UIImage *starIcon = [UIImage imageNamed:@"collect_icon_off"];
        _starButton = [[UIBarButtonItem alloc]initWithImage:starIcon style:UIBarButtonItemStylePlain target:self action:@selector(starButtonPressed:)];
    }
    return _starButton;
}

-(UIBarButtonItem *)rocketButton
{
    if (!_rocketButton) {
        UIImage *rocketIcon = [UIImage imageNamed:@"rocket_on"];
        UIImageView *rocketImageView = [[UIImageView alloc]initWithImage:rocketIcon];
        _rocketButton = [[UIBarButtonItem alloc] initWithCustomView:rocketImageView];
    }
    return _rocketButton;
}

-(UIButton *)favorInnerButton
{
    if (!_favorInnerButton) {
        UIImage *likeOffIcon = [UIImage imageNamed:@"like_icon_off"];
        _favorInnerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [_favorInnerButton setImage:likeOffIcon forState:UIControlStateNormal];
        [_favorInnerButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchDragInside];
    }
    return _favorInnerButton;
}

@end
