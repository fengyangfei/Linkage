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
#import <SVProgressHUD/SVProgressHUD.h>

@interface VCWebBrowserViewController ()
@property (nonatomic, assign) BOOL showsURLBar;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, readonly) UIButton *favorInnerButton;
@property (nonatomic, readonly) UIButton *starInnerButton;
@property (nonatomic, readonly) UIBarButtonItem *starButton;
@property (nonatomic, strong) UIBarButtonItem *rocketButton;
@property (nonatomic, strong) UIBarButtonItem *favorButton;
@property (nonatomic, readonly) UITextField *urlTextField;
@property (nonatomic) BOOL favorStatus;
@property (nonatomic) BOOL starStatus;
@end

@implementation VCWebBrowserViewController
@synthesize favorButton = _favorButton;
@synthesize starButton = _starButton;
@synthesize rocketButton = _rocketButton;
@synthesize favorInnerButton = _favorInnerButton;
@synthesize starInnerButton = _starInnerButton;
@synthesize urlTextField = _urlTextField;

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
        self.showsURLInNavigationBar = NO;
        self.showsURLBar = YES;
    }
    return self;
}

-(void)setupData
{
    @weakify(self);
    if(self.wkWebView) {
        self.urlStr = self.wkWebView.URL.absoluteString;
        //查询收藏状态
        [VCFavorUtil getModelByUrl:self.urlStr completion:^(id<MTLJSONSerializing> model) {
            @strongify(self);
            if (model) {
                self.favorStatus = YES;
            }else{
                self.favorStatus = NO;
            }
        }];
        //收藏
        [RACObserve(self, favorStatus) subscribeNext:^(id x) {
            @strongify(self);
            if ([x boolValue]) {
                UIImage *likeOffIcon = [UIImage imageNamed:@"like_icon_on"];
                [self.favorInnerButton setImage:likeOffIcon forState:UIControlStateNormal];
            }else{
                UIImage *likeOffIcon = [UIImage imageNamed:@"like_icon_off"];
                [self.favorInnerButton setImage:likeOffIcon forState:UIControlStateNormal];
            }
        }];
        
        //查询标签状态
        [VCPageUtil getModelByUrl:self.urlStr completion:^(id<MTLJSONSerializing> model) {
            @strongify(self);
            if (model) {
                self.starStatus = YES;
            }else{
                self.starStatus = NO;
            }
        }];
        //标签
        [RACObserve(self, starStatus) subscribeNext:^(id x) {
            @strongify(self);
            if ([x boolValue]) {
                UIImage *collectionIcon = [UIImage imageNamed:@"collect_icon_on"];
                [self.starInnerButton setImage:collectionIcon forState:UIControlStateNormal];
            }else{
                UIImage *collectionIcon = [UIImage imageNamed:@"collect_icon_off"];
                [self.starInnerButton setImage:collectionIcon forState:UIControlStateNormal];
            }
        }];
    }
}

-(NSArray *)bottomBarItems
{
    NSArray *barButtonItems = [super bottomBarItems];
    
    NSString *URLString;
    if(self.wkWebView) {
        URLString = [self.wkWebView.URL absoluteString];
    }
    else if(self.uiWebView) {
        URLString = [self.uiWebViewCurrentURL absoluteString];
    }
    self.urlTextField.text = URLString;
    
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
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:self.urlTextField];
    self.navigationItem.leftBarButtonItem = searchItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 事件处理
//添加到标签
-(void)starButtonPressed:(id)sender
{
    @weakify(self);
    if (self.uiWebViewIsLoading) {
        [SVProgressHUD showErrorWithStatus:@"网页加载未完成"];
        return;
    }
    [self saveStar:^{
        @strongify(self);
        [[NSNotificationCenter defaultCenter] postNotificationName:kPageUpdateNotification object:nil];
        UIImage *collectionIcon = [UIImage imageNamed:@"collect_icon_on"];
        [self.starInnerButton setImage:collectionIcon forState:UIControlStateNormal];
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
    if (self.uiWebViewIsLoading) {
        [SVProgressHUD showErrorWithStatus:@"网页加载未完成"];
        return;
    }
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
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            }];
        }];
        alertView.attachedView.mm_dimBackgroundBlurEnabled = NO;
        alertView.attachedView.mm_dimBackgroundBlurEffectStyle = UIBlurEffectStyleDark;
        [alertView show];
    }else{
        [self deleteFavor:^{
            @strongify(self);
            self.favorStatus = NO;
            [SVProgressHUD showSuccessWithStatus:@"取消成功"];
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

- (void)webBrowser:(KINWebBrowserViewController *)webBrowser didFinishLoadingURL:(NSURL *)URL
{
    
}

#pragma mark - getter setter
-(UIBarButtonItem *)favorButton
{
    if (!_favorButton) {
        _favorButton = [[UIBarButtonItem alloc]initWithCustomView:self.favorInnerButton];
    }
    return _favorButton;
}

-(UIBarButtonItem *)starButton
{
    if (!_starButton) {
        _starButton = [[UIBarButtonItem alloc]initWithCustomView:self.starInnerButton];
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
        [_favorInnerButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _favorInnerButton;
}

-(UIButton *)starInnerButton
{
    if (!_starInnerButton) {
        UIImage *collectOffIcon = [UIImage imageNamed:@"collect_icon_off"];
        _starInnerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        [_starInnerButton setImage:collectOffIcon forState:UIControlStateNormal];
        [_starInnerButton addTarget:self action:@selector(starButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _starInnerButton;
}

-(UITextField *)urlTextField
{
    if (!_urlTextField) {
        _urlTextField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH - 84, 32)];
        _urlTextField.backgroundColor = HEXCOLOR(0xf0f0f0);
        _urlTextField.layer.cornerRadius = 5.0;
        _urlTextField.layer.masksToBounds = YES;
        _urlTextField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _urlTextField.leftViewMode = UITextFieldViewModeAlways;
        _urlTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _urlTextField;
}

@end
