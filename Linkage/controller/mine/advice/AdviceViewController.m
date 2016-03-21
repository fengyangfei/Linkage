//
//  AdviceViewController.m
//  Linkage
//
//  Created by Mac mini on 16/3/4.
//  Copyright © 2016年 LA. All rights reserved.
//

#import "AdviceViewController.h"
#import <IQKeyboardManager/KeyboardManager.h>
#import <XLForm/XLFormTextView.h>
@interface AdviceViewController ()

@property (strong, nonatomic) XLFormTextView *textView;
@end

@implementation AdviceViewController

+(void)load
{
    [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[self class]];
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"建议";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5, 8, 5, 8));
    }];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.textView becomeFirstResponder];
}


- (void)doneAction
{
    [self.textView resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
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
