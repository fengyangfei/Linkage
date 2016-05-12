//
//  CommentViewController.m
//  Linkage
//
//  Created by Mac mini on 16/5/10.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CommentViewController.h"
#import "Order.h"
#import "AXRatingView.h"
#import "LoginUser.h"
#import "YGRestClient.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <XLForm/XLFormTextView.h>

@interface CommentViewController()
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) AXRatingView *ratingView;
@property (nonatomic, readonly) XLFormTextView *textView;

@end

@implementation CommentViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize titleLabel = _titleLabel;
@synthesize ratingView = _ratingView;
@synthesize textView = _textView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(submitComment)];
    [self setupUI];
}

-(void)submitComment
{
    NSDictionary *parameter = @{
                                @"order_id":((Order *)self.rowDescriptor.value).orderId,
                                @"score":@(self.ratingView.value),
                                @"comment":self.textView.text ?:@""
                                };
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [[YGRestClient sharedInstance]postForObjectWithUrl:CommentUrl form:parameter success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
    } failure:^(NSError *error) {
        
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(8);
        make.left.equalTo(self.view.left).offset(8);
    }];
    
    [self.view addSubview:self.ratingView];
    [self.ratingView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.top);
        make.left.equalTo(self.titleLabel.right).offset(8);
        make.width.equalTo(180);
        make.bottom.equalTo(self.titleLabel.bottom);
    }];
    
    [self.view addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.bottom).offset(8);
        make.left.equalTo(self.view.left).offset(8);
        make.right.equalTo(self.view.right).offset(-8);
        make.height.equalTo(250);
    }];
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"评分：";
    }
    return _titleLabel;
}

-(AXRatingView *)ratingView
{
    if (!_ratingView) {
        _ratingView = [[AXRatingView alloc]initWithFrame:CGRectZero];
        _ratingView.stepInterval = 1;
        _ratingView.value = 5;
    }
    return _ratingView;
}

-(UITextView *)textView
{
    if (!_textView) {
        _textView = [XLFormTextView new];
        _textView.placeholder = @"请输入您的意见";
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [UIColor blackColor];
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.cornerRadius = 5;
    }
    return _textView;
}

@end
