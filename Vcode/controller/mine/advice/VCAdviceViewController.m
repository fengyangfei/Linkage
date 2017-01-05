//
//  VCAdviceViewController.m
//  Linkage
//
//  Created by Mac mini on 2017/1/5.
//  Copyright © 2017年 LA. All rights reserved.
//

#import "VCAdviceViewController.h"
#import "BFPaperButton.h"
#import "LoginUser.h"
#import "YGRestClient.h"
#import <IQKeyboardManager/KeyboardManager.h>
#import <XLForm/XLFormTextView.h>
#import <Mantle/NSDictionary+MTLJSONKeyPath.h>
#import <SVProgressHUD/SVProgressHUD.h>
@interface VCAdviceViewController ()
@property (strong, nonatomic) XLFormTextView *textView;

@end

@implementation VCAdviceViewController

+(void)load
{
    [[IQKeyboardManager sharedManager] disableDistanceHandlingInViewControllerClass:[self class]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"建议反馈";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doneAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.view.backgroundColor = BackgroundColor;
    
    [self.view addSubview:self.textView];
    [self.textView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(18);
        make.left.equalTo(self.view.left);
        make.right.equalTo(self.view.right);
        make.height.equalTo(@(200));
    }];
    
    /*
     UIView *bottomView = [UIView new];
     bottomView.backgroundColor = BackgroundColor;
     [self.view addSubview:bottomView];
     [bottomView makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(self.view.left);
     make.right.equalTo(self.view.right);
     make.bottom.equalTo(self.view.bottom);
     make.height.equalTo(54);
     }];
     
     BFPaperButton *button = ({
     BFPaperButton *button = [[BFPaperButton alloc]initWithRaised:NO];
     button.cornerRadius = 4;
     [button setBackgroundImage:ButtonBgImage forState:UIControlStateNormal];
     [button setBackgroundImage:ButtonBgImage forState:UIControlStateHighlighted];
     [button setBackgroundImage:ButtonDisableBgImage forState:UIControlStateDisabled];
     [button setTitleFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20.f]];
     [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
     [button setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
     NSAttributedString *title = [[NSAttributedString alloc]initWithString:@"电话" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]}];
     [button setAttributedTitle:title forState:UIControlStateNormal];
     [button addTarget:self action:@selector(forgetAction:) forControlEvents:UIControlEventTouchUpInside];
     button;
     });
     [bottomView addSubview:button];
     [button makeConstraints:^(MASConstraintMaker *make) {
     make.left.equalTo(bottomView.left).offset(10);
     make.right.equalTo(bottomView.right).offset(-10);
     make.top.equalTo(bottomView.top).offset(5);
     make.height.equalTo(@44);
     }];
     */
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)doneAction
{
    [self.textView resignFirstResponder];
    NSDictionary *paramter = @{
                               @"content":self.textView.text,
                               @"mobile":[LoginUser shareInstance].mobile ?:@"",
                               @"email":[LoginUser shareInstance].email ?:@""
                               };
    paramter = [paramter mtl_dictionaryByAddingEntriesFromDictionary:[LoginUser shareInstance].baseHttpParameter];
    [[YGRestClient sharedInstance] postForObjectWithUrl:AdviceUrl form:paramter success:^(id responseObject) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功"];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"提交失败"];
    }];
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
        _textView.placeholder = @"请输入您的建议";
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.textColor = [UIColor blackColor];
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _textView;
}

@end
