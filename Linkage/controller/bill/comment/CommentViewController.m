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
#import "Comment.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <XLForm/XLFormTextView.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface CommentViewController()
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) AXRatingView *ratingView;
@property (nonatomic, readonly) XLFormTextView *textView;
@property (nonatomic, readonly) UILabel *hintLabel;
@end

@implementation CommentViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize titleLabel = _titleLabel;
@synthesize ratingView = _ratingView;
@synthesize textView = _textView;
@synthesize hintLabel = _hintLabel;

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"评论";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(submitComment)];
    [self setupUI];
    [self setupData];
    @weakify(self);
    [[self.textView rac_textSignal] subscribeNext:^(NSString *x) {
        @strongify(self);
        self.hintLabel.text = [NSString stringWithFormat:@"%lu/200字", (unsigned long)x.length];
    }];
}

-(void)submitComment
{
    WeakSelf
    NSDictionary *parameter = @{
                                @"order_id":((Order *)self.rowDescriptor.value).orderId,
                                @"score":@(self.ratingView.value),
                                @"comment":self.textView.text ?:@""
                                };
    parameter = [[LoginUser shareInstance].baseHttpParameter mtl_dictionaryByAddingEntriesFromDictionary:parameter];
    [[YGRestClient sharedInstance] postForObjectWithUrl:CommentUrl form:parameter success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"评论成功"];
        if (responseObject[@"id"]) {
            Order *order = weakSelf.rowDescriptor.value;
            Comment *comment = [[Comment alloc]init];
            comment.commentId = responseObject[@"id"];
            comment.comment = parameter[@"comment"];
            comment.score = parameter[@"score"];
            order.comment = comment;
        }
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setupUI
{
    self.view.backgroundColor = BackgroundColor;
    
    UIView *titleContentView = [UIView new];
    {
        titleContentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:titleContentView];
        [titleContentView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.top).offset(12);
            make.left.equalTo(self.view.left);
            make.right.equalTo(self.view.right);
            make.height.equalTo(48);
        }];
        
        [titleContentView addSubview:self.titleLabel];
        [self.titleLabel makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleContentView.left).offset(18);
            make.centerY.equalTo(titleContentView.centerY);
        }];
        
        [titleContentView addSubview:self.ratingView];
        [self.ratingView makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.right).offset(13);
            make.width.equalTo(180);
            make.centerY.equalTo(titleContentView.centerY);
        }];
    }
    
    UIView *textContentView = [UIView new];
    {
        textContentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:textContentView];
        [textContentView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleContentView.bottom).offset(12);
            make.left.equalTo(self.view.left);
            make.right.equalTo(self.view.right);
            make.height.equalTo(187);
        }];
        
        [textContentView addSubview:self.textView];
        [self.textView makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(textContentView.top).offset(13);
            make.left.equalTo(textContentView.left).offset(18);
            make.right.equalTo(textContentView.right).offset(-18);
            make.bottom.equalTo(textContentView.bottom).offset(-30);
        }];
        
        [textContentView addSubview:self.hintLabel];
        [self.hintLabel makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.textView.bottom).offset(5);
            make.right.equalTo(self.textView.right);
        }];
    }
}

-(void)setupData
{
    Order *order = self.rowDescriptor.value;
    if (order && order.comment) {
        Comment *comment = order.comment;
        if (StringIsNotEmpty(comment.commentId)) {
            [self.ratingView setEnabled:NO];
            self.ratingView.value = [comment.score intValue];
            [self.textView setEditable:NO];
            self.textView.text = comment.comment;
            [self.hintLabel setHidden:YES];
            [self.navigationItem.rightBarButtonItem setEnabled:NO];
        }
    }
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.text = @"评分";
        _titleLabel.textColor = IndexTitleFontColor;
    }
    return _titleLabel;
}

-(AXRatingView *)ratingView
{
    if (!_ratingView) {
        _ratingView = [[AXRatingView alloc]initWithFrame:CGRectZero];
        _ratingView.markImage = [UIImage imageNamed:@"star_off_score"];
        _ratingView.baseColor = [UIColor lightGrayColor];
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
        _textView.textColor = IndexTitleFontColor;
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.cornerRadius = 5;
    }
    return _textView;
}

-(UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [UILabel new];
        _hintLabel.text = @"0/200字";
        _hintLabel.textColor = HEXCOLOR(0xa8a8a8);
        _hintLabel.font = [UIFont systemFontOfSize:14];
        _hintLabel.textAlignment = NSTextAlignmentRight;
    }
    return _hintLabel;
}

@end
