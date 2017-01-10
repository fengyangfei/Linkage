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

@interface VCWebBrowserViewController ()
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, readonly) UIButton *favorInnerButton;
@property (nonatomic) BOOL favorStatus;
@end

@implementation VCWebBrowserViewController
@synthesize favorButton = _favorButton;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 事件处理
- (void)likeButtonPressed:(UIButton *)button {
    @weakify(self);
    if(!self.favorStatus){
        [self saveFavor:^{
            @strongify(self);
            self.favorStatus = YES;
        }];
    }else{
        [self deleteFavor:^{
            @strongify(self);
            self.favorStatus = NO;
        }];
    }
}

- (void)saveFavor:(void(^)(void))completion
{
    NSString *title;
    if(self.wkWebView) {
        title = self.wkWebView.title;
        self.urlStr = self.wkWebView.URL.absoluteString;
    }
    else if(self.uiWebView) {
        title = [self.uiWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    VCFavor *favor = [[VCFavor alloc]init];
    favor.title = title;
    favor.url = self.urlStr;
    favor.createdDate = [NSDate date];
    
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
