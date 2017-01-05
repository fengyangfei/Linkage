//
//  VCAboutViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCAboutViewController.h"

@interface VCAboutViewController ()
@property (nonatomic) UIWebView *webView;
@end

@implementation VCAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:241/255 green:241/255 blue:241/255 alpha:1];
    [self.view addSubview:self.webView];
    //NSString *enUrl = [NSString stringWithFormat:@"%@/about_en.html",VBaseUrl];
    NSString *cnUrl = [NSString stringWithFormat:@"%@/about.html", VBaseUrl];
    NSURL* url = [NSURL URLWithString:cnUrl];//创建URL
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
