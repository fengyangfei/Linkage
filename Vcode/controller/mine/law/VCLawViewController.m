//
//  VCLawViewController.m
//  Linkage
//
//  Created by lihaijian on 2017/2/7.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCLawViewController.h"
#import "VCThemeManager.h"

@interface VCLawViewController ()
@property (nonatomic) UIWebView *webView;

@end

@implementation VCLawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255 green:241/255 blue:241/255 alpha:1];
    [self.view addSubview:self.webView];
    NSString *urlStr;
    if([VCThemeManager shareInstance].themeType == VCThemeTypeCN){
        urlStr = VLegalNoticesCNUrl;
    }else{
        urlStr = VLegalNoticesENUrl;
    }
    NSURL* url = [NSURL URLWithString:urlStr];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    self.webView.scalesPageToFit = YES;
    [self.webView loadRequest:request];
}

-(UIWebView *)webView{
    if (!_webView) {
        CGRect bouds = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) ;
        _webView = [[UIWebView alloc]initWithFrame:bouds];
        _webView.scrollView.bounces = NO;
    }
    return _webView;
}

@end
