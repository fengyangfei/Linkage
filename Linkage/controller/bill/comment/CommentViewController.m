//
//  CommentViewController.m
//  Linkage
//
//  Created by Mac mini on 16/5/10.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "CommentViewController.h"
#import "AXRatingView.h"
#import <XLForm/XLFormTextView.h>

@interface CommentViewController()
@property (nonatomic, readonly) AXRatingView *ratingView;
@property (nonatomic, readonly) XLFormTextView *textView;

@end

@implementation CommentViewController
@synthesize ratingView = _ratingView;
@synthesize textView = _textView;

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
    }
    return _textView;
}

@end
