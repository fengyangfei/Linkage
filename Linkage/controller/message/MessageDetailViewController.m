//
//  MessageDetailViewController.m
//  Linkage
//
//  Created by Mac mini on 16/8/16.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "Message.h"
#import "NSString+Hint.h"

@interface MessageDetailViewController()
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UITextView *contentView;
@end

@implementation MessageDetailViewController
@synthesize rowDescriptor = _rowDescriptor;
@synthesize titleLabel = _titleLabel;
@synthesize contentView = _contentView;

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    Message *message = self.rowDescriptor.value;
    self.title = message.title;
    self.contentView.attributedText = [message.introduction attributedStringWithFont:[UIFont systemFontOfSize:14] color:IndexTitleFontColor];
}

-(void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    [self.contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UITextView *)contentView
{
    if (!_contentView) {
        _contentView = [[UITextView alloc]init];
        _contentView.editable = NO;
    }
    return _contentView;
}

@end
