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
@end

@implementation VCWebBrowserViewController

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)likeButtonPressed:(id)sender {
    [self saveFavor:nil];
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

#pragma mark - KINWebBrowserDelegate
- (void)webBrowser:(KINWebBrowserViewController *)webBrowser didStartLoadingURL:(NSURL *)URL
{
    self.urlStr = URL.absoluteString;
}

@end
